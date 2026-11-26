{
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    openssh.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;

    fprintd.enable = true;

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="06cb", ATTR{idProduct}=="00f9", TEST=="power/control", ATTR{power/control}="on"
    '';
  };

  security.pam.services = {
    sudo.fprintAuth = true;
    hyprlock.fprintAuth = true;
  };
}
