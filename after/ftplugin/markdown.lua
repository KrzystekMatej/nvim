local links = require("config.link_navigation")

links.map_gx(function()
  local node = links.node_at_cursor("markdown", true)
  while node and node:type() ~= "inline_link" do
    node = node:parent()
  end
  if not node then
    return
  end

  for child in node:iter_children() do
    if child:type() == "link_destination" then
      local destination = vim.treesitter.get_node_text(child, 0)
      if destination:match("^<?#.") then
        links.jump_to_tag()
        return true
      end
      return
    end
  end
end)
