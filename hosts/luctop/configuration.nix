{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../settings
    ../../services/procurator.nix
  ];

  # latest kernel to try to avoid errors with AMD Radeon 890M gpu
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Ensure AMD GPU firmware is available
  hardware.firmware = [pkgs.linux-firmware];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # AMDGPU specific kernel parameters to help with stability
  boot.kernelParams = [
    "amdgpu.sg_display=0" # Fixes some display freezes on newer AMD APUs
    "amdgpu.dcdebugmask=0x12" # Workaround for PSR-related freezes
  ];

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = [
      # pkgs.opensc
      # pkgs.qdigidoc
      # pkgs.pcsc-tools
      # pkgs.ccid
      # pkgs.web-eid-app
      # pkgs.p11-kit

      # https://github.com/open-eid/DigiDoc4-Client/pull/1371
      # https://github.com/open-eid/DigiDoc4-Client/issues/1281

      pkgs.curl
      pkgs.git

      pkgs.home-manager
    ];
    # etc = {
    #   "chromium/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
    #   "opt/chrome/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
    # };
  };

  networking = {
    hostName = "luctop";
    # speed up DHCP: don't block boot while dhcpcd waits for leases
    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };
  };

  # systemd.services = {
  #         NetworkManager-wait-online.enable = false;
  #         systemd-udev-settle.enable = false;
  #       };

  #  this shit is ai generated, i don't trust it
  # systemd = {
  #     services = {
  #       "nix-gc.service" = { mask = true; };
  #       "NetworkManager-wait-online.service" = { mask = true; };
  #       "systemd-tmpfiles-clean.service" = { mask = true; };
  #       "docker.service" = { mask = true; }; # if you want docker only socket-activated
  #     };

  #     timers = {
  #       "systemd-tmpfiles-clean.timer" = { enable = true; };
  #       "nix-gc.timer" = { mask = true; };
  #     };

  #     sockets = {
  #       "docker.socket" = { enable = true; };
  #     };
  #   };
  # TODO: maybe worth testing again the tuxedo control center
  # hardware.tuxedo-control-center.enable = true;

  services = {
    # TODO: maybe move this to the user home-manager
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
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
    gnome.gnome-keyring = {
      enable = true;
    };
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

  system.stateVersion = stateVersion;
}
