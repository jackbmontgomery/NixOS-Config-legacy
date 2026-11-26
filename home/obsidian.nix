{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.obsidian = {
    enable = true;

    defaultSettings = {
      app = {
        alwaysUpdateLinks = true;
        spellcheck = true;
        vimMode = false;
        readableLineLength = true;
      };

      cssSnippets = [
        {
          name = "Line width";
          text = ''
            body {
              --file-line-width: 100ch;
            }
          '';
        }
      ];

      appearance = {
        showViewHeader = false;
      };

      corePlugins = [
        "backlink"
        "command-palette"
        "file-explorer"
        "global-search"
        "graph"
        "outline"
        "page-preview"
        "properties"
        "tag-pane"
        {
          name = "templates";
          settings = {
            folder = "Templates";
            dateFormat = "DD-MMM-YYY";
            timeFormat = "HH:mm";
          };
        }
        "word-count"
        "workspaces"
        "slides"
        "switcher"
        "slash-command"
        "sync"
      ];
      communityPlugins = with pkgs.obsidianPlugins; [
        vim-motions
        {
          pkg = obsidian-hider;
          settings = {
            hideStatus = false;
            hideTabs = true;
            hideScroll = false;
            hideSidebarButtons = true;
            hideTooltips = true;
            hideFileNavButtons = true;
            hideSearchSuggestions = true;
            hideSearchCounts = true;
            hideInstructions = true;
            hidePropertiesReading = true;
            hideVault = true;
          };
        }
      ];
    };

    vaults."Obsidian" = {
      enable = true;
      target = "Obsidian";
      settings = {
        appearance = {
          baseFontSize = 20;
        };
      };
    };
  };

  home.file."Obsidian/.obsidian.init.lua".text = ''
    vim.g.mapleader = " "
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.textwidth = 100
    vim.opt.clipboard = "unnamedplus"
    vim.keymap.set('n', '-', ':Oil<CR>')
    vim.opt.whichkey = "all"

    vim.keymap.set("n", "j", function()
        if vim.v.count == 0 then
            return "gj"
        else
            return vim.v.count1 .. "j"
        end
    end, { expr = true, silent = true })

    vim.keymap.set("n", "k", function()
        if vim.v.count == 0 then
            return "gk"
        else
            return vim.v.count1 .. "k"
        end
    end, { expr = true, silent = true })
  '';

  home.file."Obsidian/prettierrc.json".source = (pkgs.formats.json {}).generate "prettierrc.json" {
    proseWrap = "always";
    printWidth = 120;
    tabWidth = 4;
    useTabs = true;
  };
}
