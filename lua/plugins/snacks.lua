return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>n", false },
      {
        "<leader>sN",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },
    },
    opts = {
      explorer = {
        enabled = false,
      },
    },
  },
}
