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
    inherit stateVersion;
    username = mainUser;
    homeDirectory = "/home/${mainUser}";
  };

  home.sessionVariables = {
    XDG_SESSION_TYPE="wayland";
  };

}
