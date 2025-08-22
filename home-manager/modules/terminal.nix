{
  programs = {
    ghostty = {
      enable = true;
      installVimSyntax = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        keybind = [
          "ctrl+s>k=goto_split:top"
          "ctrl+s>h=goto_split:left"
          "ctrl+s>j=goto_split:bottom"
          "ctrl+s>l=goto_split:right"
          "ctrl+s>c=new_split:right"
          "ctrl+s>enter=toggle_split_zoom"
        ];
        gtk-tabs-location = "hidden";
        gtk-single-instance = true;
        window-decoration = false;
        auto-update = "off";
        confirm-close-surface = false;
      };
    };
    alacritty.enable = false;
  };
}
