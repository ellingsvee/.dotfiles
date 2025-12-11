-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Double tap leader to go to previous buffer
vim.keymap.set("n", "<leader><leader>", "<C-6>", { desc = "Go to previous buffer", remap = true })

-- delete single character without copying into register
vim.keymap.set(
  "n",
  "x",
  '"_x',
  { desc = "Delete single character without copying into register", noremap = true, silent = true }
)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', { desc = "Keep last yanked when pasting", noremap = true, silent = true })

-- Make * highlight the current word
vim.keymap.set("n", "*", "*N", { desc = "Make * highlight the current word", noremap = true, silent = true })

-- -- Quit using C-q
vim.keymap.set("n", "<C-q>", ":q<CR>", { desc = "Quit current buffer", noremap = true, silent = true })
