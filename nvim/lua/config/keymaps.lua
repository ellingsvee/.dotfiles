-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Double tap leader to go to previous buffer
vim.keymap.set('n', '<leader><leader>', '<C-6>', { desc = "Go to previous buffer", remap = true })
