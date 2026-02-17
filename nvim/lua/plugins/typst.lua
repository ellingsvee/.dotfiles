return {
  -- install tinymist
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "tinymist",
      },
    },
  },
  -- set up nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            formatterMode = "typstyle",
            exportPdf = "onSave",
            semanticTokens = "disable",
          },
        },
      },
    },
  },
  -- typst-preview
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {
      open_cmd = "open -a qutebrowser %s",
    },
    keys = {
      { "<leader>tp", "<cmd>TypstPreview<cr>", ft = "typst", desc = "Typst Preview (qutebrowser)" },
    },
  },
}
