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

  # Ensure AMD GPU firmware is available
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    firmware = [pkgs.linux-firmware];
  };

  boot = {
    # latest kernel to try to avoid errors with AMD Radeon 890M gpu
    kernelPackages = pkgs.linuxPackages_latest;
    # AMDGPU specific kernel parameters to help with stability
    kernelParams = [
      "amdgpu.sg_display=0" # Fixes some display freezes on newer AMD APUs
      "amdgpu.dcdebugmask=0x12" # Workaround for PSR-related freezes
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = [
      # pkgs.opensc
      pkgs.qdigidoc
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

  systemd = {
    timers = {
      systemd-tmpfiles-clean = {
        timerConfig = {
          OnBootSec = "15min"; # delay after boot
        };
      };
      nix-gc = {
        timerConfig = {
          OnBootSec = "15min"; # delay GC after boot, don't run immediately
        };
      };
    };
    services = {
      nix-gc = {
        serviceConfig = {
          IOSchedulingClass = "idle"; # run GC with low I/O priority
          CPUSchedulingPolicy = "idle"; # run GC with low CPU priority
        };
      };
      NetworkManager-wait-online.enable = false;
    };
  };

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
    # Enable Avahi to reach lucver.local
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };

  users.users.lucas.extraGroups = ["adbusers"];

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

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  system.stateVersion = stateVersion;
}
