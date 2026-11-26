{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./keymaps.nix
    ./iron.nix
    ./autocmds.nix
    ./notes.nix
    ./languages.nix
    ./utility.nix
    ./statusline.nix
  ];
  stylix.targets.neovim.enable = false;
  stylix.targets.nvf.enable = false;

  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;
      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };
      globals = {
        tex_flavor = "latex";
      };
      undoFile.enable = true;
      opts = {
        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        showmode = false;
        breakindent = true;
        ignorecase = true;
        smartcase = true;
        conceallevel = 1;
        foldlevel = 99;
        foldenable = true;
        scrolloff = 8;
      };
      theme = {
        enable = true;
        name = "rose-pine";
        style = "main";
      };
      autopairs.nvim-autopairs.enable = true;
      diagnostics = {
        enable = true;
        nvim-lint = {
          enable = true;
          lint_after_save = true;
        };
      };
      snippets.luasnip = {
        enable = true;
        customSnippets.snipmate.markdown = [
          {
            trigger = "end_slide";
            description = "presenterm slide break";
            body = "<!-- end_slide -->";
          }
          {
            trigger = "pause";
            description = "presenterm pause ";
            body = "<!-- pause -->";
          }
          {
            trigger = "speaker_note";
            description = "presenterm speaker note";
            body = "<!-- speaker_note: -->";
          }
        ];
      };
      autocomplete = {
        blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
          setupOpts = {
            signature = {
              enabled = true;
              trigger.show_on_insert = true;
              window = {
                border = "rounded";
                show_documentation = true;
              };
            };
            completion.documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
              window.border = "rounded";
            };
            completion.menu.border = "rounded";
          };
        };
      };
      telescope = {
        enable = true;
        mappings = {
          lspDefinitions = "gd";
          lspTypeDefinitions = "<leader>lgt";
          lspImplementations = "<leader>lgi";
          lspReferences = "gr";
          lspDocumentSymbols = "<leader>lS";
          lspWorkspaceSymbols = "<leader>lws";
        };
      };
      extraPlugins = {
        vim-tpipeline.package = pkgs.vimPlugins.vim-tpipeline;
      };

      globals = {
        tpipeline_autoembed = 0;
        tpipeline_restore = 0;
        tpipeline_cursormoved = 0;
      };
      visuals.nvim-web-devicons.enable = true;

      ui = {
        noice.enable = true;
      };
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };
      terminal.toggleterm = {
        enable = true;
        mappings.open = "<leader>tt";
        setupOpts = {
          direction = "float";
        };
      };
      navigation = {
        harpoon = {
          enable = true;
          mappings = {
            file1 = "<leader>1";
            file2 = "<leader>2";
            file3 = "<leader>3";
            file4 = "<leader>4";
            listMarks = "<leader>hm";
            markFile = "<leader>ha";
          };
        };
      };
    };
  };
}
