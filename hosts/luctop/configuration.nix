{
  pkgs,
  stateVersion,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../nixos/modules
    ../../services/postgres.nix
  ];

  environment.systemPackages = [pkgs.home-manager];

  networking.hostName = hostname;

  # TODO: maybe move this to the user home-manager
  # Configure keymap in X11
  # This seems not used, it follows only the hyprland settings
  services.xserver.xkb = {
    layout = "es,us";
    variant = "";
  };

  # services.xserver.xkb = {
  #   layout = "es";
  #   variant = "nodeadkeys";
  # };

  # Configure console keymap
  # console.keyMap = "es";

  services.printing.enable = true;
  services.printing.drivers = [pkgs.cnijfilter2];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    nix-ld.enable = true;
    seahorse.enable = true;
  };
  services.gnome.gnome-keyring = {enable = true;};
  virtualisation.docker.enable = true;
  # Files, browser, screen sharing stuff
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  system.stateVersion = stateVersion;
}
