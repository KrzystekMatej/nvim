return {
  "mikesmithgh/kitty-scrollback.nvim",
  lazy = true,
  cmd = {
    "KittyScrollbackGenerateKittens",
    "KittyScrollbackCheckHealth",
    "KittyScrollbackGenerateCommandLineEditing",
  },
  event = "User KittyScrollbackLaunch",
  opts = {},
  main = "kitty-scrollback",
}
