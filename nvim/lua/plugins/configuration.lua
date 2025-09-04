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

  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")

      -- Setup options
      ls.config.setup({
        update_events = { "TextChanged", "TextChangedI" },
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
      })
      -- Load your custom snippets from lua/snippets
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets/" })

      -- Keymaps for choice nodes
      vim.keymap.set({ "i", "s" }, "<C-n>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { desc = "Cycle to next choice in Luasnip" })

      vim.keymap.set({ "i", "s" }, "<C-p>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end, { desc = "Cycle to previous choice in Luasnip" })

      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if ls.expand_or_locally_jumpable() then
          ls.expand_or_jump()
        end
      end, { desc = "Jump to next location" })

      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if ls.locally_jumpable(-1) then
          ls.jump(-1)
        end
      end, { desc = "Jump to prev location" })
    end,
  },
}
