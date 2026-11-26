{lib, ...}: {
  programs.nvf.settings.vim = {
    augroups = [
      {name = "jbm";}
    ];
    autocmds = [
      {
        event = ["TextYankPost"];
        group = "jbm";
        desc = "Highlight when yanking text";
        callback = lib.generators.mkLuaInline ''
          function()
              vim.highlight.on_yank()
          end
        '';
      }
      {
        event = ["ColorScheme"];
        pattern = ["*"];
        group = "jbm";
        desc = "Keep laststatus=0 while vim-tpipeline owns the statusline";
        callback = lib.generators.mkLuaInline ''
          function()
              vim.schedule(function()
                if vim.g.loaded_tpipeline == 1 then
                  vim.o.laststatus = 0
                end
              end)
          end
        '';
      }
      {
        event = ["BufEnter" "WinEnter" "BufWritePost" "BufModifiedSet"];
        pattern = ["*"];
        group = "jbm";
        desc = "Push lualine's statusline to vim-tpipeline on buffer changes";
        callback = lib.generators.mkLuaInline ''
          function()
              if vim.g.loaded_tpipeline ~= 1 then
                return
              end
              local ok, lualine = pcall(require, "lualine")
              if ok then
                lualine.refresh({place = {"statusline"}, force = true})
              end
              pcall(vim.fn["tpipeline#lualine#fix_stl"])
          end
        '';
      }
      {
        event = ["OptionSet"];
        pattern = ["background"];
        group = "jbm";
        desc = "Keep laststatus=0 after a background flip reloads lualine";
        callback = lib.generators.mkLuaInline ''
          function()
              vim.schedule(function()
                if vim.g.loaded_tpipeline == 1 then
                  vim.o.laststatus = 0
                end
              end)
          end
        '';
      }
    ];
  };
}
