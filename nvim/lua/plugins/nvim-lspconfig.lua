-- return {
--   "neovim/nvim-lspconfig",
--   opts = {
--     inlay_hints = { enabled = false },
--   },
-- }
return {
  "neovim/nvim-lspconfig",
  opts = {
    -- global LSP options
    inlay_hints = { enabled = false },

    servers = {
      -- Disable Pyright variants
      pyright = { enabled = false },
      basedpyright = { enabled = false },

      -- Enable ty
      ty = {
        enabled = true,
        settings = {
          ty = {
            -- put Astral ty settings here if needed
            -- example:
            -- pythonVersion = "3.11",
          },
        },
      },

      -- Optional: keep Ruff if you want linting
      ruff = {
        enabled = true,
      },
    },
  },
}
