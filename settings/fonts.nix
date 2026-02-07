{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    packages =
      [
        pkgs.twemoji-color-font
        pkgs.fira-code
        pkgs.fira-code-symbols
        pkgs.font-awesome
      ]
      ++ builtins.filter lib.attrsets.isDerivation
      (builtins.attrValues pkgs.nerd-fonts);
  };
}
