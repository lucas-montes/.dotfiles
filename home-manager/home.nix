{
  lib,
  stateVersion,
  mainUser,
  ...
}: {
  imports = [./modules ./home-packages.nix];

  home = {
    inherit stateVersion;
    username = mainUser;
    homeDirectory = "/home/${mainUser}";
    activation = {
      myActivationAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run mkdir -p ~/Downloads/music
        run mkdir -p ~/Notes
        run mkdir -p ~/Projects
        if [ ! -d ~/Projects/procurator ]; then
          run git clone git@github.com:lucas-montes/procurator.git ~/Projects/procurator
        fi
        verboseEcho "Activation complete for user directories."
      '';
    };
  };

  home.sessionVariables = {XDG_SESSION_TYPE = "wayland";};
}
