return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        python = { "ruff_fix", "ruff_format" }, -- The ruff-fix handles the imports
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },
}
