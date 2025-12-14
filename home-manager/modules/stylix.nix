{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.stylix.homeModules.stylix];

  home.packages = [
    pkgs.jetbrains-mono
    pkgs.font-awesome
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = import ../colorscheme.nix;

    targets = {
      tmux.enable = false;
      hyprland.enable = false;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 13;
    };

    fonts = {
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.font-awesome;
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
