{
  pkgs,
  stateVersion,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos/modules
    ../../services/postgres.nix
  ];

  environment.systemPackages = [
    pkgs.home-manager
    pkgs.openrgb
    pkgs.curl
    pkgs.wget
    pkgs.git
    pkgs.cudatoolkit
  ];

  networking.hostName = hostname;

  services = {
    printing.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    gnome.gnome-keyring = {enable = true;};
    hardware.openrgb.enable = true;
  };

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
