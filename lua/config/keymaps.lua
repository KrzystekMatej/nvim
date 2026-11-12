-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-q>", "<cmd>close<cr>", { desc = "Close Window" })

vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move Left" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move Down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move Up" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move Right" })

-- Reserve <leader>l for loading; keep LazyVim's plugin manager under <leader>ll.
pcall(vim.keymap.del, "n", "<leader>l")
vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy Plugin Manager" })

vim.keymap.set("n", "<leader>lc", function()
	require("config.load").load_configuration()
end, { desc = "Load Configuration" })

vim.keymap.set("n", "<leader>lp", function()
	require("config.load").load_plugin()
end, { desc = "Load Plugin" })
