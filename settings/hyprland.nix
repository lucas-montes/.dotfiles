{
  pkgs,
  mainUser,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # set the flake package
    # package =
    #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # # make sure to also set the portal package, so that they are in sync
    # portalPackage =
    #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/hyprland";
        user = mainUser;
        # The arg is user not mainUser, if you change it, it get stuck in the boot screen and there are no errors
      };
      default_session = initial_session;
    };
  };

  security.pam.services.hyprlock = {};
}
