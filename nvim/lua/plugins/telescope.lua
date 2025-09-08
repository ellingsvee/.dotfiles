return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader><space>", false }, -- Disable as I instead use this as a keymap
    { "<leader>sf", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
  },
}
