return {
  {
    "ibhagwan/fzf-lua",

    keys = {
      {
        "<C-x><C-f>",
        function()
          require("fzf-lua").complete_file({
            cmd = "rg --files",
          })
        end,
        mode = "i",
        desc = "Fuzzy complete file",
      },
    },
  },
}
