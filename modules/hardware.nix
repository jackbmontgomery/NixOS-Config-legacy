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

    # YICHIP JLab GO Keys external keyboard: right Win -> right Alt, right Alt -> right Ctrl,
    # so the bottom row matches the ThinkPad layout (left Alt/Win swap is handled via Hyprland kb_options).
    udev.extraHwdb = ''
      evdev:input:b0003v145Fp02FC*
       KEYBOARD_KEY_700e7=rightalt
       KEYBOARD_KEY_700e6=rightctrl
    '';
  };
  zramSwap.enable = true;
  hardware.graphics.enable = true;
}
