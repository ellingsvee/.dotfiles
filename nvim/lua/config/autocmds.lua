-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- wrap and check for spell in latex
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "latex", "tex", "typst", "typ" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- sortcut for fixing spelling errors
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "latex", "tex", "typst", "typ", "markdown", "md" },
  callback = function()
    -- mapping: Ctrl+. to correct previous spelling mistake
    vim.api.nvim_buf_set_keymap(0, "i", "<C-f>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { noremap = true, silent = true })
  end,
})
