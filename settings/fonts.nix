{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    packages = [
      pkgs.noto-fonts-color-emoji
      pkgs.jetbrains-mono
      pkgs.nerd-fonts.symbols-only
    ];
  };
}
