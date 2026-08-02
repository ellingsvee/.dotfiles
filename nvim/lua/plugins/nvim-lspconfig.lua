local function read_spellfile(path)
  local words = {}

  local file = io.open(vim.fn.expand(path), "r")
  if not file then
    return words
  end

  for line in file:lines() do
    if line ~= "" and not line:match("^#") then
      table.insert(words, line)
    end
  end

  file:close()
  return words
end --

return {
  "neovim/nvim-lspconfig",
  opts = {
    -- global LSP options
    inlay_hints = { enabled = false },

    servers = {
      -- Disable Pyright variants
      pyright = { enabled = false },
      basedpyright = { enabled = false },

      -- Enable ty
      ty = {
        enabled = true,
        settings = {
          ty = {
            -- put Astral ty settings here if needed
            -- example:
            -- pythonVersion = "3.11",
          },
        },
      },

      -- Optional: keep Ruff if you want linting
      ruff = {
        enabled = true,
      },

      -- LTeX LSP server
      servers = {
        ltex = {
          filetypes = {
            "bib",
            "gitcommit",
            "latex",
            "markdown",
            "org",
            "plaintex",
            "rst",
            "rnoweb",
            "tex",
          },
          settings = {
            ltex = {
              -- Choose one:
              -- language = "en-US",
              -- language = "en-GB",
              language = "en-US",
              dictionary = {
                ["en-US"] = read_spellfile("~/.config/nvim/spell/en.utf-8.add"),
              },

              additionalRules = {
                enablePickyRules = true,
              },
            },
          },
        },
      },
    },
  },
}
