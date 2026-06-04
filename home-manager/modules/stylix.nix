{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.stylix.homeModules.stylix];

  home.packages = [pkgs.jetbrains-mono pkgs.font-awesome];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = import ../colorscheme.nix;

    targets = {
      tmux.enable = false;
      firefox.enable = false;
      hyprland.enable = false;
      gnome.enable = false;
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
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      monospace = {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      };
    };

    image = ../../wallpaper.png;
  };
}
