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
          # A fresh install may be offline and without SSH keys; tolerate a
          # failed clone so profile activation never blocks a first boot.
          run git clone git@github.com:lucas-montes/procurator.git ~/Projects/procurator || verboseEcho "procurator clone skipped (offline or no SSH keys)"
        fi
        verboseEcho "Activation complete for user directories."
      '';
    };
  };

  home.sessionVariables = {XDG_SESSION_TYPE = "wayland";};
}
