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

  environment = {
    systemPackages = [
      pkgs.opensc
      pkgs.pcsc-tools
      pkgs.web-eid-app
      pkgs.qdigidoc
      pkgs.ccid

      pkgs.curl
      pkgs.wget
      pkgs.git
      pkgs.cudatoolkit

      pkgs.home-manager
    ];
    etc = {
      "chromium/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
      "opt/chrome/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
    };
  };

  networking.hostName = hostname;

  services = {
    # TODO: maybe move this to the user home-manager
    # Configure keymap in X11
    xserver.xkb = {
      layout = "latam,us";
      variant = "";
    };
    openssh.enable = true;
    pcscd = {
      enable = true;
    };
    printing = {
      enable = true;
      drivers = [pkgs.gutenprint];
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

  # Virtualisation
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["lucas"];

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    docker.enable = true;
  };

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
