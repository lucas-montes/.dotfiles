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
          text = "$TIME";
          font_size = 64;
          font_family = "JetBrains Mono";
          position = "0, 10";
          valign = "top";
          halign = "center";
          color = "rgba(0, 0, 0, 1)";
        }
        # {
        #   monitor = "";
        #   text = ''
        #     Hello <span text_transform="capitalize" size="larger">$USER!</span>'';
        #   font_size = 20;
        #   font_family = "JetBrains Mono Nerd Font 10";
        #   position = "0, 14";
        #   valign = "top";
        #   halign = "center";
        #   color = "rgba(0, 0, 0, 1)";
        # }
      ];
    };
  };
}
