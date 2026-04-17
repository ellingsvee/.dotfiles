return {
  {
    "igorlfs/nvim-dap-view",
    -- let the plugin lazy load itself
    lazy = false,
    version = "1.*",
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      winbar = {
        default_section = "repl",
      },
      windows = {
        size = 0.25,
        position = "below",
        terminal = {
          size = 0.5,
          position = "left",
          -- List of debug adapters for which the terminal should be ALWAYS hidden
          hide = {},
        },
      },
    },
    keys = {
      { "<leader>dv", "<cmd>DapViewToggle<cr>", desc = "Toggle Dap View" },
    },

    config = function(_, opts)
      local dap = require("dap")
      local dapview = require("dap-view")
      dapview.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapview.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapview.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapview.close()
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
  -- stylua: ignore
    opts = {},
    -- config = function(_, opts)
    --   local dap = require("dap")
    --   local dapui = require("dapui")
    --   dapui.setup(opts)
    --   -- dap.listeners.after.event_initialized["dapui_config"] = function()
    --   --   dapui.open({})
    --   -- end
    --   dap.listeners.before.event_terminated["dapui_config"] = function()
    --     dapui.close({})
    --   end
    --   dap.listeners.before.event_exited["dapui_config"] = function()
    --     dapui.close({})
    --   end
    -- end,
  },
}
