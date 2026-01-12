{ lib, ... }: {
  programs.waybar = {
    enable = true;
    style = lib.mkAfter (builtins.readFile ./style.css);
    settings = [{
      "layer" = "top";
      "position" = "top";
      modules-left = [ "custom/maia" ];
      modules-center = [ "clock" ];
      modules-right =
        [ "group/hardware" "network" "hyprland/language" "battery" ];

      "hyprland/language" = { format = "{short} {variant}"; };

      "custom/maia" = {
        exec = "$HOME/Projects/maia/target/debug/cli waybar";
        format = "  {}";
        interval = 60;
        tooltip = true;
      };

      battery = {
        interval = 60;
        states = {
          warning = 30;
          critical = 15;
        };

        format = "{icon} {capacity}%";

        format-icons = [ "" "" "" "" "" ];

        max-length = 25;
      };

      "clock" = {
        format = "  {:%A - %B | %d/%m/%Y - %R}";
        tooltip = true;
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
      };
      memory = {
        "interval" = 1;
        "format" = "󰻠 {percentage}%";
        "states" = { "warning" = 85; };
      };

      cpu = {
        "interval" = 1;
        "format" = "󰍛 {usage}%";
      };

      disk = {
        "interval" = 30;
        "format" = "D {percentage_used}% ";
        "path" = "/";
      };

      "temperature" = {
        "hwmon-path-abs" = "/sys/devices/platform/coretemp.0/hwmon";
        "input-filename" = "temp1_input";
        "critical-threshold" = 80;
        "format" = " {temperatureC}°C";
      };

      "group/hardware" = {
        "orientation" = "horizontal";
        "modules" = [ "cpu" "memory" "disk" "temperature" ];
      };

      "network" = {
        format = "{icon} {ipaddr}";
        format-wifi = "{icon} {signalStrength}%";
        format-ethernet = "{icon} {ipaddr}";
        format-linked = " (no IP)";
        format-disconnected = "󰖪 Disconnected";

        format-icons = {
          wifi = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ]; # from low to high signal
          ethernet = "󰈀";
          linked = "󰈁";
          disconnected = "󰖪";
        };

        tooltip = true;
        tooltip-format = "{ifname}: {ipaddr} via {gwaddr}";
        tooltip-format-wifi = ''
          SSID: {essid}
          Signal: {signalStrength}% ({signaldBm} dBm)
          IP: {ipaddr}
          Gateway: {gwaddr}
          Up: {bandwidthUpBits}bps
          Down: {bandwidthDownBits}bps
        '';
        tooltip-format-ethernet = ''
          Interface: {ifname}
          IP: {ipaddr}
          Gateway: {gwaddr}
          Up: {bandwidthUpBits}bps
          Down: {bandwidthDownBits}bps
        '';
        tooltip-format-disconnected = "No active connection";

        on-click = "nm-connection-editor"; # Launch NetworkManager GUI
      };
    }];
  };
}
