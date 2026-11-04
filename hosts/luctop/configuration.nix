{
  pkgs,
  mainUser,
  stateVersion,
  ...
}: {
  imports = [
    ../../settings
    ../../services/procurator.nix
    ../../services/bandtrack.nix
    ../../services/maia.nix
    ./hardware-configuration.nix
  ];

  hardware.firmware = [pkgs.linux-firmware];

  boot = {
    # Pinned to the newest kernel known to work with this flake's ZFS release.
    # linuxPackages_latest can move past ZFS's supported kernel range and break evaluation.
    kernelPackages = pkgs.linuxPackages_7_2;

    # /tmp in RAM speeds up compilation (object files, cargo/go build dirs
    # avoid ZFS writes) and pairs with the zram tuning in zram.nix, which
    # deliberately favors pushing cold pages into zram swap over evicting
    # the page cache under this kind of memory pressure. Capped at 8G so a
    # build that fills it can't starve the rest of the system; programs that
    # expect to write large or persistent things to /tmp or /var/tmp (e.g.
    # export CARGO_TARGET_DIR=/tmp/shackle-target) should point elsewhere.
    tmp = {
      useTmpfs = true;
      tmpfsSize = "8G";
    };

    # AMDGPU specific kernel parameters to help with stability
    kernelParams = [
      "amdgpu.sg_display=0" # Fixes some display freezes on newer AMD APUs
      # "amdgpu.dcdebugmask=0x12" # Workaround for PSR-related freezes
      "amdgpu.dcdebugmask=0x410" # Disables BOTH PSR (0x10) and Panel Replay (0x400) to prevent TV static artifacts
      # init_on_alloc zeroes every allocation as a hardening measure, but OpenZFS
      # documents that it "can lower ARC throughput considerably". This kernel
      # (7.2.6) is built with CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y and NixOS does not
      # override it, so turn it off to favor IO throughput. This trades away the
      # uninitialized-memory / use-after-free mitigation the option provides.
      # https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/Workload%20Tuning.html#init-on-alloc
      "init_on_alloc=0"
    ];
  };

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
    # Allows to change the power-policy of the cpu
    power-profiles-daemon.enable = true;
    # Cleans the ssd/nvme drive from unused blocks, to keep it healthy and fast
    fstrim.enable = false; # not needed anymore: disabled services.zfs.trim.enable in favor of continuous autotrim in disko.nix
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

  users.users.${mainUser}.extraGroups = ["adbusers"];

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
