return {
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      if vim.fn.has("win32") == 1 then
        require("dap-python").setup("uv")
      else
        require("dap-python").setup("uv")
      end
    end,
  },
}
