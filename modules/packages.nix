{
  config,
  lib,
  pkgs,
  ...
}: {
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      wev
      wget
      git
      unzip
      lxqt.lxqt-policykit
      fastfetch
      btop
      brightnessctl
      playerctl
      trash-cli
      sound-theme-freedesktop
      wl-clipboard
      vim
      tcpdump
      networkmanagerapplet # nm-connection-editor: GUI for 802.1X / wifi
      julia-bin
    ];
  };
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    poppins
  ];
}
