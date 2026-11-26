{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.hyprland.package = pkgs.unstable.hyprland;
  programs.hyprland.portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
}
