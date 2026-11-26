local M = {}

function M.map_gx(follow_link)
  local system_gx = vim.iter(vim.api.nvim_get_keymap("n")):find(function(mapping)
    return mapping.lhs == "gx"
  end)
  if not system_gx or not system_gx.callback then
    return
  end

  vim.keymap.set("n", "gx", function()
    if not follow_link() then
      system_gx.callback()
    end
  end, { buffer = true, desc = "Follow link under cursor" })

  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. "\n silent! nunmap <buffer> gx"
end

function M.node_at_cursor(language, include_injections)
  local parser = vim.treesitter.get_parser(0, language)
  if not parser then
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local range = { row - 1, col, row - 1, col + 1 }
  parser:parse(range)
  return parser:named_node_for_range(range, { ignore_injections = not include_injections })
end

function M.jump_to_tag(move_left)
  vim.cmd.normal({ args = { (move_left and "h" or "") .. vim.keycode("<C-]>") }, bang = true })
end

return M
