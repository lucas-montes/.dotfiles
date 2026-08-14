{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    # package = null;
    # portalPackage = null;
    settings = {
      monitor = ",preferred,auto,1";
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "nautilus";
      "$menu" = "rofi";
      "$browser" = "brave";

      "windowrule" = [
        "match:title ^(Picture in picture)$, float on"
        "match:title ^(Picture in picture)$, pin on"
        "match:float true, size 800 600"
      ];

      exec-once = ["waybar" "[workspace 1] $browser" "[workspace 2] $terminal"];

      general = {
        gaps_in = 5;
        gaps_out = "5,5,5,5";
        border_size = 2;
        "col.active_border" = "rgb(CBA6F7) rgb(D2F7A6) 45deg";
        "col.inactive_border" = "rgb(5cf9eb) rgb(5ecae9) 45deg";
        layout = "dwindle";
      };

      # NVIDIA-specific settings that can cause freezes on AMD:
      # cursor = {no_hardware_cursors = true;};

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };

        blur = {
          enabled = true;
          size = 12;
          passes = 3;
          new_optimizations = true;
          noise = 5.0e-2;
          ignore_opacity = true;
        };
      };

      animations = {enabled = true;};

      input = {
        kb_layout = "us";
        kb_options = "grp:alt_shift_toggle,compose:caps";
        follow_mouse = true;
      };

      gestures = {
        workspace_swipe_invert = false;
        workspace_swipe_forever = true;
      };

      dwindle = {
        preserve_split = true;
      };

      master = {new_status = "master";};

      misc = {
        force_default_wallpaper = 2;
        disable_hyprland_logo = true;
      };
    };
  };
}
