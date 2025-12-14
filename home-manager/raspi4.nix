{
  homeStateVersion,
  user,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./modules/btop.nix
    ./modules/dev.nix
    ./modules/fzf.nix
    ./modules/nvf.nix
    ./modules/shell
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/vcs.nix
    inputs.stylix.homeModules.stylix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
  };

  home.packages = [
    pkgs.jetbrains-mono
    pkgs.font-awesome
  ];

stylix = {
  autoEnable = false;
    enable = true;
    polarity = "dark";
    base16Scheme = import ./colorscheme.nix;

    targets = {
      btop.enable = true;
      starship.enable = true;
      neovim.enable = true;
      nushell.enable = true;
    };
  };

}
