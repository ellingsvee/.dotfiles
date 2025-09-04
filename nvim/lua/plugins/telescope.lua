-- return {
--   "nvim-telescope/telescope.nvim",
--   keys = {
--     -- disable the keymap to grep files
--     -- {"<leader>/", false},
--     -- change a keymap
--     -- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
--     { "<leader>sf", "<leader><leader>", desc = "Find Files" },
--   }
--   --   -- add a keymap to browse plugin files
--   --   {
--   --     "<leader>fp",
--   --     function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
--   --     desc = "Find Plugin File",
--   --   },
--   -- },
-- }
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {"<leader><space>", false}, -- Disable as I instead use this as a keymap
    { "<leader>sf", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
  }
}

