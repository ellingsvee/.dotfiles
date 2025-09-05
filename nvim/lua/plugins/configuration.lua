return {
  -- change which-key preset
  {
    "folke/which-key.nvim",
    -- opts will be merged with the parent spec
    opts = {
      preset = "classic",
    },
  },

  -- configure blink-cmp to use tab for completion
  {
    "saghen/blink.cmp",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
        ["<Tab>"] = { "select_and_accept", "fallback" },
        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },
      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 0 },
      },
      snippets = {
        preset = "luasnip",
      },
    },
  },

  -- change snacks config
  {
    "snacks.nvim",
    -- opts will be merged with the parent spec
    opts = {
      indent = { enabled = true },
      input = { enabled = false },
      notifier = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      toggle = { map = LazyVim.safe_keymap_set },
      words = { enabled = false },
      dashboard = { enabled = false },
    },
  },

  -- add timymist to the lspconfig
  -- {
  --   "neovim/nvim-lspconfig",
  --   ---@class PluginLspOpts
  --   opts = {
  --     ---@type lspconfig.options
  --     servers = {
  --       -- pyright will be automatically installed with mason and loaded with lspconfig
  --       timymist = {
  --         settings = {
  --           formatterMode = "typstyle",
  --           exportPdf = "onType",
  --           semanticTokens = "disable",
  --         },
  --       },
  --     },
  --   },
  -- },

  -- add any tools you want to have installed below
  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     ensure_installed = {
  --       "tinymist",
  --     },
  --   },
  -- },
}
