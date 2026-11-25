return {
  {
    "sheng-tse/jupynvim",
    -- The current native backend uses Unix-only APIs.
    enabled = vim.fn.has("win32") == 0,
    lazy = false,
    opts = {
      image_renderer = "placeholder",
    },
  },
}
