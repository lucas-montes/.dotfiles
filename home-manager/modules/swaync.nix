let
  c = import ../colorscheme.nix;
in {
  services.swaync = {
    enable = true;
    style =
      ''
        @define-color base00 #${c.base00};
        @define-color base01 #${c.base01};
        @define-color base02 #${c.base02};
        @define-color base03 #${c.base03};
        @define-color base04 #${c.base04};
        @define-color base05 #${c.base05};
        @define-color base06 #${c.base06};
        @define-color base07 #${c.base07};
        @define-color base08 #${c.base08};
        @define-color base09 #${c.base09};
        @define-color base0A #${c.base0A};
        @define-color base0B #${c.base0B};
        @define-color base0C #${c.base0C};
        @define-color base0D #${c.base0D};
        @define-color base0E #${c.base0E};
        @define-color base0F #${c.base0F};
        @define-color theme_fg @base05;
        @define-color theme_fg_secondary @base06;
        @define-color theme_bg @base00;
        @define-color popup_bg @base00;
        @define-color module_bg @base01;
        @define-color module_hover_bg @base02;
        @define-color button_bg @base02;
        @define-color button_hover_bg @base03;
        @define-color accent_color @base0D;
        @define-color accent_color_hover @base0D;
        @define-color border_light @base03;
        @define-color border_dark @base00;
        @define-color border_medium @base02;
        @define-color icon_primary @theme_fg;
        @define-color icon_secondary @base06;
        @define-color slider_trough_bg @base02;
        @define-color slider_thumb_bg @base05;
        @define-color close_button_bg @base02;
        @define-color close_button_hover_bg @base03;
        @define-color mpris_player_bg @base01;
      ''
      + builtins.readFile ./swaync.css;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-radius = 1;
      fit-to-screen = true;
      layer-shell = true;
      layer = "overlay";
      control-center-layer = "overlay";
      cssPriority = "user";
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;

      widgets = [
        "label"
        "title"
        "volume"
        "backlight"
        "menubar"
        "buttons-grid"
        "inhibitors"
        "dnd"
        "mpris"
        "notifications"
      ];
      widget-config = {
        buttons-grid = {
          actions = [
            {
              label = "";
              command = "nm-connection-editor";
            }
            {
              label = "";
              command = "blueman-manager";
            }
            {
              label = "";
              command = "pavucontrol";
            }
          ];
        };

        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };

        dnd = {text = "Do Not Disturb";};

        label = {
          max-lines = 1;
          text = "Control Center";
        };

        mpris = {
          image-size = 96;
          image-radius = 6;
        };

        # Run this to find your actual backlight device:
        # ls /sys/class/backlight/
        backlight = {
          label = "";
          device = "intel_backlight"; #TODO: fix
          min = 10;
        };

        "backlight#KB" = {
          label = " ";
          device = "asus::kbd_backlight";
          subsystem = "leds";
        };

        volume = {label = "";};

        menubar = {
          "menu#power-buttons" = {
            label = "";
            position = "right";
            actions = [
              {
                label = "    Reboot";
                command = "systemctl reboot";
              }
              {
                label = "    Lock";
                command = "loginctl lock-session $XDG_SESSION_ID";
              }
              {
                label = "    Logout";
                command = "loginctl terminate-session $XDG_SESSION_ID";
              }
              {
                label = "    Shut down";
                command = "systemctl poweroff";
              }
            ];
          };
        };
      };
    };
  };
}
