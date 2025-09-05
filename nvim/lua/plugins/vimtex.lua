return {
  "lervag/vimtex",
  config = function()
    vim.g.vimtex_mappings_enabled = 1
    vim.g.vimtex_syntax_conceal_disable = 1 -- Disable math conceal

    --quickfix settings
    vim.g.vimtex_quickfix_open_on_warning = 0 --  don't open quickfix if there are only warnings
    vim.g.vimtex_quickfix_ignore_filters = {
      "Underfull",
      "Overfull",
      "LaTeX Warning: .\\+ float specifier changed to",
      "Package hyperref Warning: Token not allowed in a PDF string",
    }

    -- Disable matchparen for better LaTeX experience
    vim.g.loaded_matchparen = 1
  end,
}
