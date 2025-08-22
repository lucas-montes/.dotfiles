{pkgs, ...}: {
  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
      extensions = [
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
      ];
    };
  };
}
