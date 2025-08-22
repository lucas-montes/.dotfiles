{
  programs.zathura = {
    enable = true;
    options = {
      recolor = "true";
      adjust-open = "best";
      selection-clipboard = "clipboard";
      #    "guioptions" = "none";
    };
    mappings = {
      "i" = "recolor"; # toggle recoloring
      "j" = "feedkeys <C-Down>"; # scroll down
      "k" = "feedkeys <C-Up>"; # scroll up
    };
  };
}
