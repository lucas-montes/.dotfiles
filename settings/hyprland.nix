{
  pkgs,
  mainUser,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/hyprland";
        inherit mainUser;
      };
      default_session = initial_session;
    };
  };

  security.pam.services.hyprlock = {};
}
