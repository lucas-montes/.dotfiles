{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../settings
    ../../services/postgres.nix
  ];

    nixpkgs.config.allowUnfree = true;
  hardware = {
    graphics.enable = true;
    nvidia-container-toolkit.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        amdgpuBusId = "PCI:6:0:0";
        #intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        sync.enable = false;
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };
  services.xserver.videoDrivers = ["nvidia"];

  environment.systemPackages = [
    pkgs.home-manager
    pkgs.curl
    pkgs.wget
    pkgs.git
    pkgs.cudatoolkit
  ];

  networking.hostName = "server";
  hardware.tuxedo-control-center.enable = true;

  services = {
    printing.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    gnome.gnome-keyring = {enable = true;};
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
