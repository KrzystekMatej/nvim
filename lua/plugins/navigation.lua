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
            { "<C-.>", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "i", "x" }, has = "codeAction" },
          },
        },
      },
    },
  },
}
