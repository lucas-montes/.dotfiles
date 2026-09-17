{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../settings
    ../../services/procurator.nix
    ../../services/bandtrack.nix
  ];

  hardware.firmware = [pkgs.linux-firmware];

  boot = {
    # NOTE: this is a trick to speed up compilation and some things that might require read and write to files, we keep some things in RAM instead of disk, but it might cause some issues with some programs that expect to write to /tmp or /var/tmp
    # and we would move something like export CARGO_TARGET_DIR=/tmp/shackle-target
    # tmp = {
    #   useTmpfs = true;
    #   tmpfsSize = "8G";
    # };

    # latest kernel to try to avoid errors with AMD Radeon 890M gpu
    kernelPackages = pkgs.linuxPackages_latest;
    # AMDGPU specific kernel parameters to help with stability
    kernelParams = [
      "amdgpu.sg_display=0" # Fixes some display freezes on newer AMD APUs
      # "amdgpu.dcdebugmask=0x12" # Workaround for PSR-related freezes
      "amdgpu.dcdebugmask=0x410" # Disables BOTH PSR (0x10) and Panel Replay (0x400) to prevent TV static artifacts
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
  };

  networking = {
    hostName = "luctop";
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
    # Cleans the ssd/nvme drive from unused blocks, to keep it healthy and fast
    fstrim.enable = true;
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
