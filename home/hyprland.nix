{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    settings = let
      lua = lib.generators.mkLuaInline;
      bind = key: action: {
        _args = [
          key
          (lua action)
        ];
      };
      bindo = key: action: opts: {
        _args = [
          key
          (lua action)
          (lua opts)
        ];
      };
      exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
      ws = n: ''hl.dsp.focus({ workspace = "${n}", on_current_monitor = true })'';
      mvws = n: ''hl.dsp.window.move({ workspace = "${n}" })'';
      resizeStep = 40;
      resize = x: y: let
        px = n: toString (n * resizeStep);
      in ''hl.dsp.window.resize({ x = ${px x}, y = ${px y}, relative = true })'';
    in {
      bind = [
        # Apps
        (bind "SUPER + T" (exec "kitty"))
        (bind "SUPER + B" (exec "zen-beta"))
        (bind "SUPER + N" (exec "obsidian"))
        (bind "SUPER + E" (exec "thunar"))

        (bind "SUPER + Space" (exec "wofi-open"))

        (bind "SUPER + ALT + Return" (exec "lock-screen"))
        (bind "CTRL + SUPER + ALT + Return" (exec "uwsm stop"))

        # Window management
        (bind "SUPER + Q" "hl.dsp.window.close()")

        # Special Workspace
        (bind "SUPER + Return" "hl.dsp.workspace.toggle_special()")
        (bind "SUPER + SHIFT + Return" ''hl.dsp.window.move({ workspace = "special" })'')

        # Move focus
        (bind "SUPER + ALT + H" ''hl.dsp.focus({ direction = "left" })'')
        (bind "SUPER + ALT + L" ''hl.dsp.focus({ direction = "right" })'')
        (bind "SUPER + ALT + K" ''hl.dsp.focus({ direction = "up" })'')
        (bind "SUPER + ALT + J" ''hl.dsp.focus({ direction = "down" })'')

        # Resize window
        (bindo "SUPER + SHIFT + ALT + H" (resize (-1) 0) "{ repeating = true }")
        (bindo "SUPER + SHIFT + ALT + L" (resize 1 0) "{ repeating = true }")
        (bindo "SUPER + SHIFT + ALT + K" (resize 0 (-1)) "{ repeating = true }")
        (bindo "SUPER + SHIFT + ALT + J" (resize 0 1) "{ repeating = true }")

        # Workspaces
        (bind "SUPER + J" (ws "1"))
        (bind "SUPER + K" (ws "2"))
        (bind "SUPER + L" (ws "3"))
        (bind "SUPER + semicolon" (ws "4"))

        # Move window to workspace
        (bind "SUPER + SHIFT + J" (mvws "1"))
        (bind "SUPER + SHIFT + K" (mvws "2"))
        (bind "SUPER + SHIFT + L" (mvws "3"))
        (bind "SUPER + SHIFT + semicolon" (mvws "4"))

        # Volume
        (bindo "XF86AudioRaiseVolume" (exec "osd-volume up") "{ locked = true, repeating = true }")
        (bindo "XF86AudioLowerVolume" (exec "osd-volume down") "{ locked = true, repeating = true }")
        (bindo "XF86AudioMute" (exec "osd-volume mute") "{ locked = true }")
        (
          bindo "XF86AudioMicMute"
          (exec "sh -c 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle; mic-led-sync'")
          "{ locked = true }"
        )

        # Brightness
        (bindo "XF86MonBrightnessUp" (exec "osd-brightness up") "{ locked = true, repeating = true }")
        (bindo "XF86MonBrightnessDown" (exec "osd-brightness down") "{ locked = true, repeating = true }")

        # Multimedia keys
        (bindo "SUPER + PRINT" (exec "hyprshot -m region -o ~/Screenshots") "{ locked = true }")
        (bindo "XF86SelectiveScreenshot" (exec "hyprshot -m region --clipboard-only") "{ locked = true }")

        (bindo "XF86AudioNext" (exec "playerctl next") "{ locked = true }")
        (bindo "XF86AudioPause" (exec "playerctl play-pause") "{ locked = true }")
        (bindo "XF86AudioPlay" (exec "playerctl play-pause") "{ locked = true }")
        (bindo "XF86AudioPrev" (exec "playerctl previous") "{ locked = true }")
      ];
    };

    extraConfig = ''
      hl.env("QT_QPA_PLATFORM", "wayland")
      hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
      hl.env("QT_STYLE_OVERRIDE", "Fusion")

      hl.monitor({ output = "", mode = "preferred", position = "auto-up", scale = 1 })

      hl.config({
          general =
          {
              gaps_in = 5, gaps_out = 5, border_size = 2,
              ["col.active_border"] = "rgba(78a9ffaa)", ["col.inactive_border"] = "rgba(2c2c2caa)",
              resize_on_border = true, allow_tearing = false, layout = "master"
          },

          animations = {enabled = false },

      decoration =
      {
          rounding = 10, active_opacity = 1.0, inactive_opacity = 0.7, fullscreen_opacity = 1.0,
          shadow = { enabled = true, range = 15, color = "rgba(19191966)" },
          blur = { enabled = true, size = 3, passes = 2, brightness = 0.6, contrast = 1.0, noise = 0, xray = false, popups = false }
      },

      input = { kb_layout = "us", kb_variant = "", kb_model = "thinkpad", follow_mouse = 1, sensitivity = 0, natural_scroll = true, touchpad = { natural_scroll = true } }
      })

      hl.device({
          name = "synps/2-synaptics-touchpad",
          sensitivity = 0.7,
      })

      hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
      hl.curve("snappyReturn", { type = "bezier", points = { {0.4, 0.9}, {0.6, 1.0} } })
      hl.curve("bounce", { type = "bezier", points = { {0.4, 0.9}, {0.6, 1.0} } })
      hl.curve("md3_decel", { type = "bezier", points = { {0.05, 0.7}, {0.1, 1} } })
      hl.curve("softAcDecel", { type = "bezier", points = { {0.26, 0.26}, {0.15, 1} } })

      -- Window rules
      hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
      hl.window_rule({ name = "thunar-float", match = { class = "thunar" }, float = true, size = "1000 700", center = true })
      hl.window_rule({ name = "wifi-float", match = { class = "nm-connection-editor" }, float = true, size = "640 400", center = true })
      hl.window_rule({ name = "bluetooth-float", match = { class = "blueman-manager" }, float = true, size = "640 400", center = true })
      hl.window_rule({ name = "vol-float", match = { class = "org.pulseaudio.pavucontrol" }, float = true, size = "640 400", center = true })

      hl.window_rule({ name = "gr-float", match = { class = "[Gg]ksqt" }, float = true, center = true })
      hl.window_rule({ name = "mpl-float", match = { class = "[Mm]atplotlib" }, float = true, center = true })

      hl.layer_rule({
          match = { namespace = "waybar" },
          blur = true,
          ignore_alpha = 1.0,
          order = 1,
      })

      hl.on("window.open", function(w)
          hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 0, client = 0, action = "set", window = w }))
      end)

      hl.on("hyprland.start", function()
          hl.exec_cmd("waybar")
          hl.exec_cmd("lxqt-policykit-agent")
          hl.exec_cmd("nm-applet --indicator")
          hl.exec_cmd("mic-led-sync")
      end)
    '';
  };
}
