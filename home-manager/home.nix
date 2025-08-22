{
  homeStateVersion,
  user,
  ...
}: {
  imports = [
    ./modules
    ./home-packages.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
  };

  home.sessionVariables = {
    XDG_SESSION_TYPE="wayland";
  };

}
