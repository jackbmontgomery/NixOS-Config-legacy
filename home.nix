{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./home/gtk.nix
    ./home/zsh.nix
    ./home/thunar.nix
    ./home/hyprland.nix
    ./home/kitty.nix
    ./home/waybar.nix
    ./home/scripts.nix
    ./home/wofi.nix
    ./home/desktop-entries.nix
    ./home/hypridle.nix
    ./home/hyprlock.nix
    ./home/dunst.nix
    ./home/python.nix
    ./home/zen.nix
    ./home/git.nix
    ./home/obsidian.nix
    ./home/tmux.nix
    ./home/tex.nix
    ./home/zathura.nix
    ./home/julia.nix
    ./home/nvim
  ];

  home = {
    username = "jbm";
    homeDirectory = "/home/jbm";
    stateVersion = "26.05";
  };
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.colloid-icon-theme
    pkgs.pavucontrol
    pkgs.networkmanagerapplet
    pkgs.libnotify
    pkgs.hyprshot
    pkgs.hyprpicker
    pkgs.zotero
    pkgs.ripgrep
    pkgs.speedtest-go
    pkgs.rustup
    pkgs.gcc
    pkgs.cmake
    pkgs.gnumake
    pkgs.claude-code
    pkgs.ffmpeg
    pkgs.presenterm
    pkgs.pandoc
    pkgs.typst
  ];
  xdg = {
    configFile = {
      "presenterm/themes/dark-transparent.yaml".source =
        ./home/presenterm/dark-transparent.yaml;

      "presenterm/themes/light-transparent.yaml".source =
        ./home/presenterm/light-transparent.yaml;

      "presenterm/config.yaml".text = ''
        defaults:
          theme: light-transparent
          max_columns: 80
          max_columns_alignment: center
          max_rows: 20
          max_rows_alignment: center
        export:
          pauses: new_slide
          dimensions:
            columns: 80
            rows: 20
      '';
    };
  };

  home.sessionVariables.DIFFSOL_JAX_PJRT_PLUGIN = "${config.home.homeDirectory}/.local/share/pjrt/pjrt_c_api_cpu_plugin.so";
  programs.imv = {
    enable = true;
    settings = {
      options = {
        overlay = true;
        overlay_text = "[\${imv_current_index}/\${imv_file_count}] \${imv_current_file##*/}";
      };
    };
  };
}
