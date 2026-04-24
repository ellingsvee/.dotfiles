return {
  { "JuliaEditorSupport/julia-vim" },
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "zsh" },
            },
          },
          -- set the file type of the newly created repl to ft
          -- bufnr is the buffer id of the REPL and ft is the filetype of the
          -- language being used for the REPL.
          repl_filetype = function(bufnr, ft)
            return ft
            -- or return a string name such as the following
            -- return "iron"
          end,
          -- Send selections to the DAP repl if an nvim-dap session is running.
          dap_integration = true,
          -- How the repl window will be displayed
          -- See below for more information
          -- repl_open_cmd = view.bottom(40),
          repl_open_cmd = view.split.vertical.botright(0.4),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          toggle_repl = "<space>rr", -- toggles the repl open and closed.
          -- If repl_open_command is a table as above, then the following keymaps are
          -- available
          -- toggle_repl_with_cmd_1 = "<space>rv",
          -- toggle_repl_with_cmd_2 = "<space>rh",
          restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
          -- send_motion = "<space>rc",
          visual_send = "<space>rs",
          -- send_file = "<space>sf",
          -- send_line = "<space>rs",
          -- send_paragraph = "<space>sp",
          send_until_cursor = "<space>ru",
          -- send_mark = "<space>rm",
          -- send_code_block = "<space>sb",
          -- send_code_block_and_move = "<space>sn",
          -- mark_motion = "<space>mc",
          -- mark_visual = "<space>mc",
          -- remove_mark = "<space>md",
          -- cr = "<space>s<cr>",
          -- interrupt = "<space>s<space>",
          exit = "<space>rq",
          clear = "<space>rc",
        },
        -- keymaps = {
        --   toggle_repl = "<space>rr", -- toggles the repl open and closed.
        --   -- If repl_open_command is a table as above, then the following keymaps are
        --   -- available
        --   -- toggle_repl_with_cmd_1 = "<space>rv",
        --   -- toggle_repl_with_cmd_2 = "<space>rh",
        --   restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
        --   send_motion = "<space>sc",
        --   visual_send = "<space>sc",
        --   send_file = "<space>sf",
        --   send_line = "<space>sl",
        --   send_paragraph = "<space>sp",
        --   send_until_cursor = "<space>su",
        --   send_mark = "<space>sm",
        --   send_code_block = "<space>sb",
        --   send_code_block_and_move = "<space>sn",
        --   mark_motion = "<space>mc",
        --   mark_visual = "<space>mc",
        --   remove_mark = "<space>md",
        --   cr = "<space>s<cr>",
        --   interrupt = "<space>s<space>",
        --   exit = "<space>sq",
        --   clear = "<space>cl",
        -- },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      })

      -- iron also has a list of commands, see :h iron-commands for all available commands
      vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
      vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { silent = true })
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { silent = true })
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { silent = true })
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { silent = true })
    end,
  },
}
