if vim.fn.has("win32") == 0 then
  return {}
end

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- OmniSharp v2 dropped the -net6.0 suffix, but Mason still requests it.
      -- Remove this registry once the upstream package uses the new filenames.
      opts.registries = opts.registries or { "github:mason-org/mason-registry" }
      table.insert(opts.registries, 1, "lua:config.mason_registry")
    end,
  },
}
