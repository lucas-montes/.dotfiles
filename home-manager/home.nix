{
  stateVersion,
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
    stateVersion = stateVersion;
  };

  home.sessionVariables = {
    XDG_SESSION_TYPE="wayland";
  };

}
