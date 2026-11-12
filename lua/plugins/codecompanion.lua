return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      require("config.codecompanion_sessions").setup()
    end,
    keys = {
      -- CodeCompanion reads the active selection in Visual mode.
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "x" }, desc = "AI Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI Chat" },
      { "<leader>an", "<cmd>CodeCompanionChat<cr>", mode = { "n", "x" }, desc = "New AI Chat" },
      { "<leader>ae", "<cmd>CodeCompanionChat Changes<cr>", desc = "AI Edited Files" },
      { "<leader>al", "<cmd>CodeCompanionList<cr>", desc = "List Project AI Chats" },
      { "<leader>aL", "<cmd>CodeCompanionList!<cr>", desc = "AI Chat History (All Projects)" },
      { "<leader>ad", "<cmd>CodeCompanionDelete<cr>", desc = "Delete AI Chat" },
      { "<leader>aD", "<cmd>CodeCompanionDelete!<cr>", desc = "Delete AI Chat (All Projects)" },
      {
        "<leader>as",
        function()
          require("config.codecompanion_settings").open()
        end,
        desc = "AI Session Settings",
      },
      {
        "<leader>ai",
        function()
          require("config.codecompanion_settings").open("reasoning_effort")
        end,
        desc = "AI Reasoning Effort",
      },
      {
        "<leader>am",
        function()
          require("config.codecompanion_settings").open("model")
        end,
        desc = "AI Model",
      },
      {
        "<leader>ap",
        function()
          require("config.codecompanion_settings").open("mode")
        end,
        desc = "AI Permission Mode",
      },
    },
    opts = {
      adapters = {
        acp = {
          codex = function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "chat-gpt",
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "codex",
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>a", group = "AI", mode = { "n", "x" } },
      },
    },
  },
}
