{
  lib,
  pkgs,
  ...
}: {
  programs.nvf.settings.vim = {
    extraPlugins.iron-nvim.package = pkgs.vimPlugins.iron-nvim;
    luaConfigRC.iron = {
      data = ''
        local iron = require("iron.core")
        local view = require("iron.view")
        local common = require("iron.fts.common")

        iron.setup {
          config = {
            scratch_repl = true,
            repl_definition = {
              sh = {
                command = {"zsh"}
              },
              python = {
                command = { "ipython", "--no-autoindent" },
                format = common.bracketed_paste_python,
                block_dividers = { "# %%", "#%%" },
                env = {
                  PYTHON_BASIC_REPL = "1",
                  MPLBACKEND = "TkAgg",
                },
              },
              julia = {
                command = { 'julia', '--project=.' },
                format = common.bracketed_paste,
                block_dividers = { '# %%', '#%%' },
              },
            },
            dap_integration = true,
            repl_open_cmd = view.right(50),
          },
          keymaps = {
            toggle_repl = "<space>rr", -- toggles the repl open and closed.
            restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
            exit = "<space>rq",
            send_motion = "<space>sc",
            visual_send = "<space>sc",
            send_file = "<space>sf",
            send_line = "<space>sl",
            send_paragraph = "<space>sp",
            send_until_cursor = "<space>su",
            send_mark = "<space>sm",
            send_code_block = "<space>sb",
            send_code_block_and_move = "<space>sn",
            mark_motion = "<space>mc",
            mark_visual = "<space>mc",
            remove_mark = "<space>md",
            cr = "<space>s<cr>",
            interrupt = "<space>s<space>",
            clear = "<space>cl",
          },
          highlight = {
            italic = true
          },
          ignore_blank_lines = true,
        }
        vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
        vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "iron",
          group = vim.api.nvim_create_augroup("ironTermKeys", { clear = true }),
          desc = "Let terminal-mode keys leave the iron REPL",
          callback = function(args)
            local function tmap(lhs, rhs)
              vim.keymap.set("t", lhs, rhs, { buffer = args.buf })
            end
            for _, d in ipairs({ "h", "j", "k", "l" }) do
              tmap("<C-" .. d .. ">", [[<C-\><C-n><C-w>]] .. d)
            end
            tmap("<Esc>", [[<C-\><C-n>]])
          end,
        })
      '';
      after = ["pluginConfigs"];
      before = [];
    };
  };
}
