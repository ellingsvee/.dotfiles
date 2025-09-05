return {
  {
    "L3MON4D3/LuaSnip",

    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_lua").load({ paths = "./snippets" })
        end,
      },
    },

    opts = {
      update_events = { "TextChanged", "TextChangedI" },
      enable_autosnippets = true,
      store_selection_keys = "<Tab>",
    },

    keys = function()
      local ls = require("luasnip")
      return {
        {
          "<C-n>",
          function()
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end,
          mode = { "i", "s" },
          desc = "Next choice",
        },
        {
          "<C-p>",
          function()
            if ls.choice_active() then
              ls.change_choice(-1)
            end
          end,
          mode = { "i", "s" },
          desc = "Previous choice",
        },
        {
          "<C-l>",
          function()
            if ls.expand_or_locally_jumpable() then
              ls.expand_or_jump()
            end
          end,
          mode = { "i", "s" },
          desc = "Jump forward",
        },
        {
          "<C-h>",
          function()
            if ls.locally_jumpable(-1) then
              ls.jump(-1)
            end
          end,
          mode = { "i", "s" },
          desc = "Jump backward",
        },
      }
    end,
  },
}
