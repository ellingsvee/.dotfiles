-- Use the following command to restart dbus-daemon
-- dbus-daemon --fork --session --address=$DBUS_SESSION_BUS_ADDRESS
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

    --vimtex_view_settings
    -- vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
  end,
}
