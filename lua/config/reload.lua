local M = {}
local root = vim.fn.stdpath("config")
local sources = {}
local plugin_keys = {}
local plugin_snapshots = {}
local initialized = {}
local configured = false
local reloading = false

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "Config reload" })
end

local function termcodes(text)
	return vim.api.nvim_replace_termcodes(text, true, true, true)
end

local function mapping(mode, lhs, buffer)
	if buffer and not vim.api.nvim_buf_is_valid(buffer) then
		return
	end
	local maps = buffer and vim.api.nvim_buf_get_keymap(buffer, mode) or vim.api.nvim_get_keymap(mode)
	local raw = termcodes(lhs)
	for _, map in ipairs(maps) do
		if map.lhsraw == raw or map.lhsrawalt == raw or termcodes(map.lhs) == raw then
			return map
		end
	end
end

local function same_mapping(a, b)
	if not a or not b then
		return a == b
	end
	return a.callback == b.callback
		and termcodes(a.rhs or "") == termcodes(b.rhs or "")
		and a.desc == b.desc
		and a.expr == b.expr
		and a.noremap == b.noremap
end

local function restore(record, value)
	if record.buffer and not vim.api.nvim_buf_is_valid(record.buffer) then
		return
	end
	if value then
		vim.keymap.set(record.mode, record.lhs, value.callback or value.rhs, {
			buffer = record.buffer,
			desc = value.desc,
			expr = value.expr == 1,
			remap = value.noremap == 0,
			silent = value.silent == 1,
			nowait = value.nowait == 1,
			replace_keycodes = value.replace_keycodes == 1,
		})
	else
		pcall(vim.keymap.del, record.mode, record.lhs, { buffer = record.buffer })
	end
end

-- Capture mappings while each user config file executes. This also lets a later
-- reload remove old definitions and roll back mappings if the file raises an error.
local function source(name)
	local path = root .. "/lua/config/" .. name .. ".lua"
	local chunk = assert(loadfile(path))
	local previous = sources[name] or {}
	local current, touched = {}, {}
	local set, del = vim.keymap.set, vim.keymap.del
	local function records(modes, lhs, opts)
		local result = {}
		local buffer = opts and opts.buffer
		if buffer == true or buffer == 0 then
			buffer = vim.api.nvim_get_current_buf()
		end
		buffer = buffer or nil
		for _, mode in ipairs(type(modes) == "table" and modes or { modes }) do
			local id = mode .. "\0" .. termcodes(lhs) .. "\0" .. tostring(buffer)
			local record = { mode = mode, lhs = lhs, buffer = buffer }
			if not touched[id] then
				record.before = mapping(mode, lhs, buffer)
				touched[id] = record
			end
			result[id] = record
		end
		return result
	end
	vim.keymap.set = function(modes, lhs, rhs, opts)
		local entries = records(modes, lhs, opts)
		set(modes, lhs, rhs, opts)
		for id, record in pairs(entries) do
			record.value = mapping(record.mode, record.lhs, record.buffer)
			current[id] = record
		end
	end
	vim.keymap.del = function(modes, lhs, opts)
		local entries = records(modes, lhs, opts)
		del(modes, lhs, opts)
		for id in pairs(entries) do
			current[id] = nil
		end
	end
	local ok, result = pcall(chunk)
	vim.keymap.set, vim.keymap.del = set, del
	if not ok then
		for _, record in pairs(touched) do
			restore(record, record.before)
		end
		error(result)
	end
	for id, record in pairs(previous) do
		if not current[id] and same_mapping(mapping(record.mode, record.lhs, record.buffer), record.value) then
			restore(record)
		end
	end
	sources[name] = current
	return result or true
end

local function globals(keys)
	local result = {}
	for id, key in pairs(keys or {}) do
		if not key.ft then
			result[id] = key
		end
	end
	return result
end

local function snapshot_plugins(mark_initialized)
	local config = require("lazy.core.config")
	local plugin = require("lazy.core.plugin")
	local keys = require("lazy.core.handler.keys")
	plugin_keys = {}
	plugin_snapshots = {}
	for name, spec in pairs(config.plugins) do
		local entries = globals(keys.resolve(plugin.values(spec, "keys", true)))
		for id, key in pairs(entries) do
			plugin_snapshots[id] = mapping(key.mode, key.lhs)
		end
		plugin_keys[name] = entries
		if mark_initialized then
			initialized[name] = true
		end
	end
end

local function validate()
	assert(loadfile(root .. "/init.lua"))
	for _, directory in ipairs({ "config", "plugins" }) do
		local base = root .. "/lua/" .. directory
		for file, kind in vim.fs.dir(base, { depth = math.huge }) do
			if kind == "file" and file:sub(-4) == ".lua" then
				assert(loadfile(base .. "/" .. file))
			end
		end
	end
end

local function initialize(spec)
	if not initialized[spec.name] and spec._.installed then
		if spec.init then
			spec.init(spec)
		end
		initialized[spec.name] = true
	end
end

local function refresh_plugins()
	local config = require("lazy.core.config")
	local plugin = require("lazy.core.plugin")
	local handler = require("lazy.core.handler")
	local keys = require("lazy.core.handler.keys")
	local old_plugins, old_spec = config.plugins, config.spec
	plugin.load()
	for _, item in ipairs(config.spec.notifs) do
		if item.level >= vim.log.levels.ERROR then
			config.plugins, config.spec = old_plugins, old_spec
			error(item.msg)
		end
	end
	local desired, before = {}, {}
	for name, spec in pairs(config.plugins) do
		spec._.cache = nil
		desired[name] = globals(keys.resolve(plugin.values(spec, "keys", true)))
	end
	-- Rebuild only global key handlers. Existing event and filetype handlers stay
	-- with their plugins and are refreshed when that plugin is explicitly reloaded.
	for name, entries in pairs(plugin_keys) do
		for id, key in pairs(entries) do
			before[id] = { mode = key.mode, lhs = key.lhs, value = mapping(key.mode, key.lhs) }
		end
		handler.handlers.keys:del({ name = name, _ = { handlers = { keys = entries } } })
	end
	for _, record in pairs(before) do
		restore(record, record.value)
	end
	local all_desired = {}
	for _, entries in pairs(desired) do
		for id in pairs(entries) do
			all_desired[id] = true
		end
	end
	for _, entries in pairs(plugin_keys) do
		for id, key in pairs(entries) do
			if not all_desired[id] then
				local record = before[id]
				local expected = key.rhs
					and {
						callback = type(key.rhs) == "function" and key.rhs or nil,
						rhs = type(key.rhs) == "string" and key.rhs or nil,
						desc = key.desc,
						expr = key.expr and 1 or 0,
						noremap = key.remap and 0 or 1,
					}
				if
					record
					and (
						same_mapping(record.value, plugin_snapshots[id])
						or (expected and same_mapping(record.value, expected))
					)
				then
					restore(record)
				end
				if not handler.handlers.keys.active[id] then
					handler.handlers.keys.managed[id] = nil
				end
			end
		end
	end
	for name, spec in pairs(config.plugins) do
		local new = not old_plugins[name]
		if new then
			initialize(spec)
			handler.resolve(spec)
			handler.enable(spec)
		end
		spec._.handlers = spec._.handlers or {}
		local merged = {}
		for id, key in pairs(spec._.handlers.keys or {}) do
			if key.ft then
				merged[id] = key
			end
		end
		for id, key in pairs(desired[name]) do
			merged[id] = key
			if spec._.loaded and key.rhs then
				vim.keymap.set(key.mode, key.lhs, key.rhs, keys.opts(key))
			end
		end
		spec._.handlers.keys = merged
		if not spec._.loaded and not new then
			handler.handlers.keys:add({ name = name, _ = { handlers = { keys = desired[name] } } })
		end
	end
	snapshot_plugins()
	vim.api.nvim_exec_autocmds("User", { pattern = "LazyRender", modeline = false })
end

function M.configuration(silent)
	if reloading then
		return false
	end
	reloading = true
	local ok, err = pcall(function()
		validate()
		refresh_plugins()
		source("options")
		source("keymaps")
	end)
	reloading = false
	if not ok then
		notify("Reload failed: " .. tostring(err), vim.log.levels.ERROR)
	elseif not silent then
		notify("Reloaded saved options, keymaps, and plugin specifications.")
	end
	return ok
end

local function load_plugin(name)
	local spec = require("lazy.core.config").plugins[name]
	initialize(spec)
	local handler = require("lazy.core.handler")
	handler.disable(spec)
	handler.resolve(spec)
	local loader = require("lazy.core.loader")
	if spec._.loaded then
		loader.reload(spec)
	else
		loader.load({ name }, { cmd = "Reload plugin" })
	end
end

function M.plugin()
	if not M.configuration(true) then
		return
	end
	local config = require("lazy.core.config")
	local choices = vim.tbl_filter(function(spec)
		return spec.name ~= "lazy.nvim" and not spec.virtual and spec._.cond ~= false
	end, vim.tbl_values(config.plugins))
	table.sort(choices, function(a, b)
		return a.name < b.name
	end)
	vim.ui.select(choices, {
		prompt = "Load / reload plugin",
		format_item = function(spec)
			local action = spec._.loaded and "reload" or (spec._.installed and "load" or "install and load")
			return spec.name .. " (" .. action .. ")"
		end,
	}, function(selected)
		if not selected then
			return
		end
		local function apply()
			local ok, err = pcall(function()
				local missing, visited, ordered = {}, {}, {}
				local function dependencies(name)
					if visited[name] then
						return
					end
					visited[name] = true
					local spec = config.plugins[name]
					for _, dependency in ipairs(spec.dependencies or {}) do
						dependencies(dependency)
					end
					table.insert(ordered, name)
					if not spec._.installed then
						table.insert(missing, name)
					end
				end
				dependencies(selected.name)
				if #missing == 0 then
					for _, name in ipairs(ordered) do
						initialize(config.plugins[name])
					end
					load_plugin(selected.name)
					return
				end
				require("lazy").install({ plugins = missing }):wait(function()
					vim.schedule(function()
						for _, name in ipairs(missing) do
							local spec = config.plugins[name]
							if not spec or not spec._.installed or require("lazy.core.plugin").has_errors(spec) then
								return notify("Installation failed. Check :Lazy for details.", vim.log.levels.ERROR)
							end
						end
						for _, name in ipairs(ordered) do
							initialize(config.plugins[name])
						end
						local loaded, error_message = pcall(load_plugin, selected.name)
						if not loaded then
							notify(tostring(error_message), vim.log.levels.ERROR)
						end
					end)
				end)
			end)
			if not ok then
				notify(tostring(err), vim.log.levels.ERROR)
			end
		end
		local cc = package.loaded["codecompanion"]
		local chats = selected.name == "codecompanion.nvim" and cc and cc.buf_get_chat() or {}
		if #chats > 0 then
			vim.ui.select({ "Cancel", "Close chats and reload" }, {
				prompt = "Reload CodeCompanion and close its " .. #chats .. " open chat buffer(s)?",
			}, function(choice)
				if choice == "Close chats and reload" then
					for _, entry in ipairs(chats) do
						entry.chat:close()
					end
					apply()
				end
			end)
		else
			apply()
		end
	end)
end

function M.setup()
	if configured then
		return
	end
	configured = true
	for _, name in ipairs({ "options", "keymaps" }) do
		local source_name = name
		package.preload["config." .. name] = function()
			return source(source_name)
		end
	end
	local group = vim.api.nvim_create_augroup("config_reload", { clear = true })
	if package.loaded["lazy.core.config"] then
		snapshot_plugins(true)
	else
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "LazyDone",
			once = true,
			callback = function()
				snapshot_plugins(true)
			end,
		})
	end
	local function which_key()
		require("which-key").add({ { "<leader>r", group = "reload" } })
	end
	if package.loaded["which-key"] then
		which_key()
	else
		vim.api.nvim_create_autocmd("User", { group = group, pattern = "VeryLazy", once = true, callback = which_key })
	end
end

return M
