-- added shortcut to close a window
vim.keymap.set("n", "<C-q>", "<cmd>close<cr>", { desc = "Close Window" })
-- to move in insert mode with h/j/k/l motions
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move Left" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move Down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move Up" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move Right" })
