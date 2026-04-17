return {
  "stevearc/quicker.nvim",
  ft = "qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},

  keys = {
    { ">", "<cmd>lua require('quicker').expand()<CR>", desc = "Expand quickfix content" },
    { "<", "<cmd>lua require('quicker').collapse()<CR>", desc = "Collapse quickfix content" },
  },
}
