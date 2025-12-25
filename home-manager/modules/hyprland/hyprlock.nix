{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };
      label = [
            {
              monitor = "";
              # text = "cmd[update:1000] echo \"<b><big> $(date +\"%H:%M:%S\") </big></b>\"";
              text = "$TIME";
              font_size = 64;
              font_family = "JetBrains Mono Nerd Font 10";
              color = "rgb(198, 160, 246)";
              position = "0, 16";
              valign = "center";
              halign = "center";
            }
            {
              monitor = "";
              text = "Hello <span text_transform=\"capitalize\" size=\"larger\">$USER!</span>";
              color = "rgb(198, 160, 246)";
              font_size = 20;
              font_family = "JetBrains Mono Nerd Font 10";
              position = "0, 100";
              halign = "center";
              valign = "center";
            }
            {
              monitor = "";
              text = "Current Layout : $LAYOUT";
              color = "rgb(198, 160, 246)";
              font_size = 14;
              font_family = "JetBrains Mono Nerd Font 10";
              position = "0, 20";
              halign = "center";
              valign = "bottom";
            }
          ];
    };
  };
}
