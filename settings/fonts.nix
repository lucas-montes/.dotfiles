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
    ];
  };
}
