return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
      if vim.fn.has("win32") == 1 and vim.fn.executable("diff") == 0 then
        local git_bin = vim.fn.fnamemodify(vim.fn.exepath("git"), ":h:h") .. "/usr/bin"
        if vim.fn.executable(git_bin .. "/diff.exe") == 1 then
          vim.env.PATH = (vim.env.PATH or "") .. ";" .. git_bin
        end
      end
    end,
    keys = {
      {
        "<leader>uu",
        "<cmd>UndotreeToggle<CR>",
        desc = "Toggle Undotree",
      },
    },
  },
}
