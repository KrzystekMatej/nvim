if vim.fn.has("win32") == 0 then
  return {}
end

return {
  {
    "mrcjkb/rustaceanvim",
    config = function(_, opts)
      -- LazyVim's default adapter setup chooses a Unix library path.
      local extension = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
      opts.dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(
          extension .. "/adapter/codelldb.exe",
          extension .. "/lldb/bin/liblldb.dll"
        ),
      }
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts)
    end,
  },
}
