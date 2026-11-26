{
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    libinput.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore";
    };

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="leds", KERNEL=="platform::micmute", RUN+="${pkgs.coreutils}/bin/chgrp input /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
    '';
  };
  zramSwap.enable = true;
  hardware.graphics.enable = true;
}
