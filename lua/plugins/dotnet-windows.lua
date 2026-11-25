if vim.fn.has("win32") == 0 then
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local server = opts.servers and opts.servers.omnisharp
      if not server or server.enabled == false then
        return
      end

      local command = server.cmd or vim.lsp.config.omnisharp.cmd
      if type(command) ~= "table" then
        return
      end
      command = vim.deepcopy(command)

      -- OmniSharp's project discovery also uses its process working directory.
      -- Start it at the detected project root when opening files from elsewhere.
      server.cmd = function(dispatchers, config)
        return vim.lsp.rpc.start(command, dispatchers, {
          cwd = config.root_dir,
          env = config.cmd_env,
          detached = config.detached,
        })
      end
    end,
  },
}
