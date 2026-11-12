return {
  {
    "vyfor/cord.nvim",
    event = "VeryLazy",
    opts = {},
    -- Close this instance before lazy.nvim clears Cord's modules to load it again.
    deactivate = function()
      local server = package.loaded["cord.server"]
      if not server then
        return
      end
      if server.manager then
        server.manager:cleanup()
      end
      if server.client then
        server.client.on_close = nil
      end
      server:cleanup()
    end,
  },
}
