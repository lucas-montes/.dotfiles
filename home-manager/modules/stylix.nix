{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.stylix.homeModules.stylix];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = import ../colorscheme.nix;

    targets = {
      tmux.enable = false;
      firefox.enable = false;
      hyprland.enable = false;
      gnome.enable = false;
      swaync.enable = false;
      neovim = {
        enable = true;
        transparentBackground = {
          numberLine = true;
          signColumn = true;
        };
      };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 13;
    };

    fonts = {
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      monospace = {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      };
    };

    image = ../../wallpaper.png;
  };
}
