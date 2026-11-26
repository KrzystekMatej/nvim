local links = require("config.link_navigation")

links.map_gx(function()
  local node = links.node_at_cursor("vimdoc")
  while node do
    local kind = node:type()
    if kind == "taglink" or kind == "optionlink" then
      -- From the closing pipe, Ctrl-] looks for a tag to the right.
      local _, end_col = node:end_()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      links.jump_to_tag(kind == "taglink" and col == end_col - 1)
      return true
    end
    node = node:parent()
  end
end)
