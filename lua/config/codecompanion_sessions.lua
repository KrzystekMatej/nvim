-- Saved Codex conversations, accessed through CodeCompanion's ACP adapter.
local M = {}
local connection
local busy = false

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.INFO, { title = "Codex conversations" })
  end)
end

local function run(work)
  if busy then
    return notify("A conversation operation is already running.", vim.log.levels.WARN)
  end
  busy = true
  require("codecompanion.utils.async").sync(function()
    local ok, err = pcall(work)
    busy = false
    if not ok then
      notify(tostring(err), vim.log.levels.ERROR)
    end
  end)()
end

local function get_connection()
  if not connection or not connection:is_ready() then
    local adapter = require("codecompanion.adapters").resolve("codex")
    assert(adapter and adapter.type == "acp", "The Codex ACP adapter is unavailable.")
    connection = require("codecompanion.acp").new({ adapter = adapter })
    if not connection:connect_and_authenticate() then
      pcall(connection.disconnect, connection)
      connection = nil
      error("Could not connect to Codex. Check :CodeCompanionChat and :messages.")
    end
  end
  assert(connection:can_list_sessions(), "This Codex adapter does not support listing sessions.")
  return connection
end

local function title(session)
  local value = session.title
  if type(value) ~= "string" or vim.trim(value) == "" then
    value = session.sessionId
  end
  return (value:gsub("%s+", " "))
end

local function label(session)
  local updated = type(session.updatedAt) == "string" and session.updatedAt:gsub("T", " "):sub(1, 16) or ""
  local cwd = type(session.cwd) == "string" and vim.fn.fnamemodify(session.cwd, ":~") or ""
  return string.format("%s  %s  [%s]  %s", updated, title(session), session.sessionId:sub(1, 8), cwd)
end

local function list_sessions(opts, cwd)
  local conn = get_connection()
  local sessions, ids, cursors = {}, {}, {}
  local cursor
  repeat
    local params = opts.all and {} or { cwd = cwd }
    params.cursor = cursor
    local result = conn:send_rpc_request("session/list", params)
    assert(result and type(result.sessions) == "table", "Could not list Codex conversations.")
    for _, session in ipairs(result.sessions) do
      if type(session.sessionId) == "string" and not ids[session.sessionId] then
        ids[session.sessionId] = true
        table.insert(sessions, session)
      end
    end
    cursor = type(result.nextCursor) == "string" and result.nextCursor ~= "" and result.nextCursor or nil
    assert(not cursor or not cursors[cursor], "Codex returned a repeated session-list cursor. Try again.")
    if cursor then
      cursors[cursor] = true
    end
  until not cursor
  table.sort(sessions, function(a, b)
    local a_time = type(a.updatedAt) == "string" and a.updatedAt or ""
    local b_time = type(b.updatedAt) == "string" and b.updatedAt or ""
    return a_time == b_time and a.sessionId < b.sessionId or a_time > b_time
  end)
  return sessions
end

local function open_chats(session_id)
  local matches = {}
  for _, entry in ipairs(require("codecompanion").buf_get_chat()) do
    local chat = entry.chat
    if chat.acp_connection and chat.acp_connection.session_id == session_id then
      table.insert(matches, chat)
    end
  end
  return matches
end

local function resume(session)
  local existing = open_chats(session.sessionId)[1]
  if existing then
    return require("codecompanion.interactions.chat").open({ ui = existing.ui })
  end
  run(function()
    local cwd = type(session.cwd) == "string" and session.cwd or vim.fn.getcwd()
    assert(vim.fn.isdirectory(cwd) == 1, "The conversation's project directory no longer exists: " .. cwd)
    local conn = get_connection()
    assert(conn:can_load_session(), "This Codex adapter does not support resuming sessions.")
    local updates = {}
    conn.session_id = session.sessionId
    conn._loading_session = true
    conn._on_session_update = function(update)
      table.insert(updates, update)
    end
    -- Use session/load directly: the plugin's load_session can create a new
    -- session after a failed load, which would hide a failure to resume.
    local ok, result = pcall(conn.send_rpc_request, conn, "session/load", {
      sessionId = session.sessionId,
      cwd = cwd,
      mcpServers = conn.adapter_modified.defaults.mcpServers or {},
    })
    conn._loading_session = nil
    conn._on_session_update = nil
    if not ok or not result then
      conn.session_id = nil
      error(
        "Could not resume "
          .. title(session)
          .. ". Close it in any other Codex client first, then retry; see :messages for details."
      )
    end
    if result.configOptions then
      conn:_apply_config_options(result.configOptions)
    end
    if vim.fs.normalize(cwd) ~= vim.fs.normalize(vim.fn.getcwd()) then
      vim.cmd.tabnew()
      vim.cmd.tcd(vim.fn.fnameescape(cwd))
    end
    local chat = require("codecompanion").chat({
      params = { adapter = "codex" },
      stop_context_insertion = true,
      auto_submit = false,
      callbacks = {
        on_created = function(created)
          -- Transfer the loaded connection before the scheduled ACP setup runs.
          created.acp_connection = conn
          conn.chat = created
          connection = nil
          require("codecompanion.interactions.chat.acp.commands").link_buffer_to_session(
            created.bufnr,
            session.sessionId
          )
          require("codecompanion.interactions.shared.watch").enable()
          created:update_metadata()
          require("codecompanion.interactions.chat.acp.render").restore_session(created, updates)
          created:set_title(title(session))
          require("codecompanion.utils").fire("ACPChatRestored", {
            bufnr = created.bufnr,
            id = created.id,
            session_id = session.sessionId,
            title = created.title,
          })
        end,
      },
    })
    assert(chat, "Could not open the resumed chat buffer.")
    notify("Resumed: " .. title(session))
  end)
end

local function delete_session(session)
  local function check_idle()
    for _, chat in ipairs(open_chats(session.sessionId)) do
      if chat.current_request then
        notify("Stop this conversation's running request before deleting it.", vim.log.levels.WARN)
        return false
      end
    end
    return true
  end
  if not check_idle() then
    return
  end
  vim.ui.select({ "Cancel", "Delete permanently" }, {
    prompt = "Delete conversation: " .. label(session) .. "?",
  }, function(choice)
    if choice ~= "Delete permanently" or not check_idle() then
      return
    end
    if vim.fn.executable("codex") ~= 1 then
      return notify("The codex executable is not on Neovim's PATH.", vim.log.levels.ERROR)
    end
    for _, chat in ipairs(open_chats(session.sessionId)) do
      chat:close()
    end
    -- ACP session/delete may only archive a thread. The native command deletes
    -- its transcript; --force avoids a second prompt after our explicit one.
    vim.system({ "codex", "delete", session.sessionId, "--force" }, { text = true }, function(result)
      if result.code == 0 then
        notify("Deleted: " .. title(session))
      else
        local message = result.stderr and result.stderr ~= "" and result.stderr or result.stdout or "Unknown error"
        notify("Deletion failed: " .. vim.trim(message), vim.log.levels.ERROR)
      end
    end)
  end)
end

local function choose(opts, deleting)
  opts = opts or {}
  local cwd = vim.fn.getcwd()
  run(function()
    local sessions = list_sessions(opts, cwd)
    local pattern = vim.fn.tolower(vim.trim(opts.pattern or ""))
    if pattern ~= "" then
      sessions = vim.tbl_filter(function(session)
        return vim.fn.tolower(title(session)):find(pattern, 1, true) ~= nil
      end, sessions)
    end
    vim.schedule(function()
      if #sessions == 0 then
        return notify("No matching conversations in " .. (opts.all and "global history." or cwd .. "."))
      end
      vim.ui.select(sessions, {
        prompt = (deleting and "Delete Codex conversation" or "Resume Codex conversation")
          .. (opts.all and " (all projects)" or " (" .. vim.fn.fnamemodify(cwd, ":~") .. ")"),
        format_item = label,
      }, function(session)
        if session then
          if deleting then
            delete_session(session)
          else
            resume(session)
          end
        end
      end)
    end)
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("CodeCompanionList", function(args)
    choose({ all = args.bang }, false)
  end, { bang = true, desc = "List saved Codex chats; ! includes all projects", force = true })
  vim.api.nvim_create_user_command("CodeCompanionDelete", function(args)
    choose({ all = args.bang, pattern = args.args }, true)
  end, {
    bang = true,
    nargs = "*",
    desc = "Choose and confirm deletion of a saved Codex chat matching a literal title substring; ! includes all projects",
    force = true,
  })
end

return M
