local bookmark_file = vim.fs.joinpath(vim.fn.stdpath("config"), "mini-files-bookmarks.json")

local function read_global_bookmarks()
  local stat, err, code = vim.uv.fs_stat(bookmark_file)
  if code == "ENOENT" then
    return {}
  end
  assert(stat, err)
  assert(stat.type == "file", "Expected a file at " .. bookmark_file)

  local bookmarks = vim.json.decode(table.concat(vim.fn.readfile(bookmark_file), "\n"))
  assert(type(bookmarks) == "table", "Expected a JSON object in " .. bookmark_file)
  for id, path in pairs(bookmarks) do
    assert(type(id) == "string" and id:match("^[A-Z]$") and type(path) == "string", "Invalid global bookmark")
  end
  return bookmarks
end

local function save_global_bookmark(id, path)
  -- Exclusive creation keeps two Neovim instances from overwriting each other's updates.
  local temp_file = bookmark_file .. ".tmp"
  local fd = assert(vim.uv.fs_open(temp_file, "wx", 384))
  local ok, err = pcall(function()
    assert(vim.uv.fs_close(fd))
    local bookmarks = read_global_bookmarks()
    bookmarks[id] = path
    assert(vim.fn.writefile({ vim.json.encode(bookmarks) }, temp_file, "s") == 0, "Could not write " .. temp_file)
    assert(vim.uv.fs_rename(temp_file, bookmark_file))
  end)
  if not ok then
    vim.uv.fs_unlink(temp_file)
    error(err, 0)
  end
end

local function register_global_bookmark(files, id, path)
  -- Callable bookmarks remain visible even if their directory is temporarily unavailable.
  files.set_bookmark(id, function()
    return path
  end)
end

local function load_global_bookmarks()
  local ok, bookmarks = pcall(read_global_bookmarks)
  if not ok then
    vim.notify("Could not read mini.files global bookmarks: " .. bookmarks, vim.log.levels.ERROR)
    return
  end

  local files = require("mini.files")
  for id, path in pairs(bookmarks) do
    register_global_bookmark(files, id, path)
  end
end

local function set_bookmark()
  local ok, id = pcall(vim.fn.getcharstr)
  if not ok or id == "" or id == "\3" or id == "\27" then
    return
  end

  local files = require("mini.files")
  local state = files.get_explorer_state()
  if not state then
    return
  end
  local path = state.branch[state.depth_focus]
  if id:match("^[A-Z]$") then
    local saved, err = pcall(save_global_bookmark, id, path)
    if not saved then
      vim.notify("Could not save mini.files global bookmark " .. id .. ": " .. err, vim.log.levels.ERROR)
      return
    end
    register_global_bookmark(files, id, path)
    vim.notify("(mini.files) Global bookmark " .. vim.inspect(id) .. " is set", vim.log.levels.INFO)
  else
    files.set_bookmark(id, path)
    vim.notify("(mini.files) Bookmark " .. vim.inspect(id) .. " is set", vim.log.levels.INFO)
  end
end

return {
  "nvim-mini/mini.files",
  lazy = false,
  init = function()
    local group = vim.api.nvim_create_augroup("MiniFilesConfig", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "MiniFilesExplorerOpen",
      callback = load_global_bookmarks,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "MiniFilesBufferCreate",
      callback = function(event)
        local buf = event.data.buf_id
        vim.keymap.set("n", "m", set_bookmark, {
          buffer = buf,
          desc = "Set bookmark (uppercase is global)",
          nowait = true,
        })

        for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
          if mapping.lhs == "'" and mapping.callback then
            vim.keymap.set("n", "'", function()
              load_global_bookmarks()
              mapping.callback()
            end, { buffer = buf, desc = "Go to bookmark", nowait = true })
            break
          end
        end

        vim.keymap.set("n", "gy", function()
          local entry = require("mini.files").get_fs_entry()
          if entry then
            vim.fn.setreg("+", entry.path, "v")
          end
        end, { buffer = buf, desc = "Copy absolute path" })
      end,
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (directory of current file)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
    {
      "<leader>fm",
      function()
        require("mini.files").open(LazyVim.root(), true)
      end,
      desc = "Open mini.files (root)",
    },
  },
  opts = {
    options = {
      use_as_default_explorer = true,
    },
  },
}
