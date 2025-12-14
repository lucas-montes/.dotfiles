{
  homeStateVersion,
  user,
  ...
}: {
  imports = [
    ./modules/btop.nix
    ./modules/dev.nix
    ./modules/fzf.nix
    ./modules/nvf.nix
    ./modules/shell
    ./modules/starship.nix
    ./modules/stylix.nix
    ./modules/tmux.nix
    ./modules/vcs.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
  };

}
