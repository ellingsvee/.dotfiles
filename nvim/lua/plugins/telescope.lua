return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader><space>", false }, -- Disable as I instead use this as a keymap
    { "<leader>sf", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { "<leader>sS", require("telescope.builtin").lsp_document_symbols, desc = "Search through document symbols" },
    {
      "<leader>ss",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = { "function", "class", "method" },
        })
      end,
      desc = "Search through functions etc.",
    },
  },
}
