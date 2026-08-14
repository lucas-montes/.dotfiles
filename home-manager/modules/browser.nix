{pkgs, ...}: {
  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--password-store=gnome-libsecret"
      ];
      extensions = [{id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}];
    };
  };
}
