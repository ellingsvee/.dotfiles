return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      layout = {
        -- preset = "telescope",
        fullscreen = true,
      },
    },
  },
  keys = {
    {
      "<leader>sf",
      function()
        Snacks.picker.files()
      end,
      desc = "Search Files",
    },
  },
}
