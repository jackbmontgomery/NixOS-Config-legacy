{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "aphrodite";
        file = "aphrodite.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "win0err";
          repo = "aphrodite-terminal-theme";
          rev = "master";
          sha256 = "sha256-PN/UUvpYNxLDV8xrs4A+OILqhxokbajCMUkIRoQO0oE=";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = [
        "git"
        "sudo"
        "timer"
      ];
    };

    shellAliases = {
      trash = "trash-put";

      # NixOS
      nrebuild = "sudo nixos-rebuild switch --flake ~/NixOS-Config#thinkpad";
      nupdate = "cd ~/NixOS-Config && nix flake update && sudo nixos-rebuild switch --flake ~/NixOS-Config#thinkpad";
      ncheck = "cd ~/NixOS-Config && nix flake check";
      ngc = "sudo nix-collect-garbage --delete-older-than 7d";

      # Git
      gs = "git status";
      ga = "git add .";
      gc = "git commit -m";
      gp = "git push";
      gl = "git log --oneline -10";
      gd = "git diff";

      # Python
      sp = "source .venv/bin/activate";
      py = "python3";
      pdf = "zathura";
    };
  };
}
