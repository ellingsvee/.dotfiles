return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      layout = {
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
