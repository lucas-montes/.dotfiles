{
  services.swaync = {
    enable = true;
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
              label = "";
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

        dnd = {
          text = "Do Not Disturb";
        };

        label = {
          max-lines = 1;
          text = "Controll Center";
        };

        mpris = {
          image-size = 96;
          image-radius = 6;
        };

        backlight = {
          label = "";
          device = "intel_backlight";
          min = 10;
        };

        "backlight#KB" = {
          label = " ";
          device = "asus::kbd_backlight";
          subsystem = "leds";
        };

        volume = {
          label = "";
        };

        menubar = {
          "menu#power-buttons" = {
            label = "";
            position = "right";
            actions = [
              {
                label = "   Reboot";
                command = "systemctl reboot";
              }
              {
                label = "   Lock";
                command = "swaylock.sh";
              }
              {
                label = "   Logout";
                command = "loginctl terminate-session $XDG_SESSION_ID";
              }
              {
                label = "   Shut down";
                command = "systemctl poweroff";
              }
            ];
          };

          "menu#powermode-buttons" = {
            label = "";
            position = "right";
            actions = [
              {
                label = "Performance";
                command = "powerprofilesctl set performance";
              }
              {
                label = "Balanced";
                command = "powerprofilesctl set balanced";
              }
              {
                label = "Power-saver";
                command = "powerprofilesctl set power-saver";
              }
            ];
          };

          "menu#screenshot-buttons" = {
            label = "";
            position = "left";
            actions = [
              {
                label = "   Entire screen";
                command = "swaync-client -cp && sleep 1 && hyprshot -m output";
              }
              {
                label = "   Select a region";
                command = "swaync-client -cp && sleep 1 && hyprshot -m region";
              }
              {
                label = "   Open screenshot menu";
                command = "swaync-client -cp && rofi-screenshot";
              }
              {
                label = "   Open screenshot folder";
                command = "exo-open $HYPRSHOT_DIR";
              }
            ];
          };

          "menu#screencast-buttons" = {
            label = "";
            position = "left";
            actions = [
              {
                label = "   Entire screen";
                command = "swaync-client -cp && sleep 1 && recording.sh toggle fullscreen";
              }
              {
                label = "   Select a region";
                command = "swaync-client -cp && sleep 1 && recording.sh toggle region";
              }
              {
                label = "   Stop";
                command = "swaync-client -cp && recording.sh stop";
              }
              {
                label = "   Open screencast folder";
                command = "$XDG_VIDEOS_DIR/Screencasts";
              }
            ];
          };
        };
      };
    };
  };
}
