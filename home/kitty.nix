{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;

    settings = {
      confirm_os_window_close = 0;
      tab_bar_style = "fade";
      tab_fade = 1;
      active_tab_font_style = "bold";
      inactive_tab_font_style = "bold";
    };

    keybindings = {
      "ctrl+shift+h" = "no_op";
      "ctrl+shift+j" = "no_op";
      "ctrl+shift+k" = "no_op";
      "ctrl+shift+l" = "no_op";
    };

    extraConfig = lib.mkAfter ''
      color8 ${config.lib.stylix.colors.withHashtag.base04}
    '';
  };
}
