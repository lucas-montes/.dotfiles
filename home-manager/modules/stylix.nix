{ pkgs, inputs, ... }: {
  imports = [ inputs.stylix.homeModules.stylix ];

  home.packages = [ pkgs.jetbrains-mono pkgs.font-awesome ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = {
      base00 = "000000"; # background default (black): 282936
      base01 = "333547"; # background secondary (dark grey): 3a3c4e
      base02 = "44475a"; # background tertiary (grey less dark): 44475a
      base03 = "6272a4"; # backgroud (light grey)
      base04 = "62d6e8"; # light foreground (blue): 62d6e8
      base05 = "f8f8f2"; # foreground (white)
      base06 = "f1f2f8"; # light background (white a little dirty)
      base07 = "f3f981"; # yellow og: f7f7f7b
      base08 = "ea51b2"; # pinker
      base09 = "d95bff"; # purple
      base0A = "3ff0a9"; # green-blue og: 00f769
      base0B = "ebff87"; # yellow
      base0C = "a1efe4"; # cyan
      base0D = "51d6f4"; # blue og: 62d6e8
      base0E = "ff55a1"; # pink og: b45bcf
      base0F = "00f769"; # green
    };

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
