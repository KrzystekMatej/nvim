-- added shortcut to close a window
vim.keymap.set("n", "<A-q>", "<cmd>close<cr>", { desc = "Close Window" })
-- to move in insert mode with h/j/k/l motions
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move Left" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move Down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move Up" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move Right" })
vim.keymap.set("n", "<leader>gb", function()
  Snacks.picker.git_branches()
end, { desc = "Git Branches" })

local function show_view(window, buffer, view)
  vim.api.nvim_win_call(window, function()
    if vim.api.nvim_get_current_buf() ~= buffer then
      vim.cmd.buffer({ args = { tostring(buffer) }, mods = { hide = true } })
    end
    vim.fn.winrestview(view)
  end)
end

local function swap_buffers(direction)
  local source = vim.api.nvim_get_current_win()
  local target = vim.fn.win_getid(vim.fn.winnr(direction))
  if target == 0 or target == source then
    return
  end

  local source_buffer = vim.api.nvim_win_get_buf(source)
  local target_buffer = vim.api.nvim_win_get_buf(target)
  if source_buffer ~= target_buffer then
    if vim.wo[source].winfixbuf or vim.wo[target].winfixbuf then
      vim.notify("Cannot swap: a window is locked to its buffer", vim.log.levels.WARN)
      return
    end
    -- The first buffer switch can briefly leave a buffer without a window.
    for _, buffer in ipairs({ source_buffer, target_buffer }) do
      local hidden = vim.bo[buffer].bufhidden
      if hidden ~= "" and hidden ~= "hide" then
        vim.notify("Cannot swap: a buffer is set to be unloaded or removed when hidden", vim.log.levels.WARN)
        return
      end
    end
  end

  local source_view = vim.fn.winsaveview()
  local target_view = vim.api.nvim_win_call(target, vim.fn.winsaveview)
  show_view(source, target_buffer, target_view)
  show_view(target, source_buffer, source_view)
  vim.api.nvim_set_current_win(target)
end

for key, direction in pairs({ h = "Left", j = "Down", k = "Up", l = "Right" }) do
  vim.keymap.set("n", "<leader>w" .. key, function()
    swap_buffers(key)
  end, { desc = "Swap Buffer " .. direction })
end
