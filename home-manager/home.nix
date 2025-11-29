{
  homeStateVersion,
  mainUser,
  ...
}: {
  imports = [
    ./modules
    ./home-packages.nix
  ];

  home = {
    username = mainUser;
    homeDirectory = "/home/${mainUser}";
    stateVersion = homeStateVersion;
  };

  home.sessionVariables = {
    XDG_SESSION_TYPE="wayland";
  };

}
