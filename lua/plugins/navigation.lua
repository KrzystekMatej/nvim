return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<C-k>"] = false,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<C-k>", false, mode = "i" },
          },
        },
      },
    },
  },
}
