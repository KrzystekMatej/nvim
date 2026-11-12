-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-q>", "<cmd>close<cr>", { desc = "Close Window" })

vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move Left" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move Down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move Up" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move Right" })

vim.keymap.set("n", "<leader>rc", function()
	require("config.reload").configuration()
end, { desc = "Reload Configuration" })

vim.keymap.set("n", "<leader>rp", function()
	require("config.reload").plugin()
end, { desc = "Reload Plugin" })
