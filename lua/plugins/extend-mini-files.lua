return {
  "nvim-mini/mini.files",
  lazy = false,
  init = function()
    local group = vim.api.nvim_create_augroup("MiniFilesCopyPath", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "MiniFilesBufferCreate",
      callback = function(event)
        vim.keymap.set("n", "gy", function()
          local entry = require("mini.files").get_fs_entry()
          if entry then
            vim.fn.setreg("+", entry.path, "v")
          end
        end, { buffer = event.data.buf_id, desc = "Copy absolute path" })
      end,
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (directory of current file)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
    {
      "<leader>fm",
      function()
        require("mini.files").open(LazyVim.root(), true)
      end,
      desc = "Open mini.files (root)",
    },
  },
  opts = {
    options = {
      use_as_default_explorer = true,
    },
  },
}
