{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode.url = "github:anomalyco/opencode";

    procurator.url = "github:lucas-montes/procurator/remote-connections";
    bandtrack.url = "github:lucas-montes/bandtrack";

    maia = {
      url = "github:lucas-montes/maia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    ...
  } @ inputs: let
    mainUser = "lucas";
    stateVersion = "25.05";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Used by `nix flake init -t <flake>#<name>`
    templates = {
      rust = {
        path = ./templates/rust;
        description = "Template for a rust project";
        welcomeText = ''
          # Getting Started
          - run `direnv allow` to enter the development environment
        '';
      };
      rustdock = {
        path = ./templates/rustdock;
        description = "Template for a rust project packaged as a docker container";
        welcomeText = ''
          # Getting Started
          - run `direnv allow` to enter the development environment
        '';
      };
      android = {
        path = ./templates/android;
        description = "Template for a android project";
        welcomeText = ''
          # Getting Started
          - run `direnv allow` to enter the development environment
        '';
      };
      python = {
        path = ./templates/python;
        description = "Template for python project";
        welcomeText = ''
          # Getting Started
          - run `direnv allow` to enter the development environment
        '';
      };
    };

    # Installer for the new SSD. Run `nix run .#install-luctop-zfs` from the
    # repo root: it formats and installs ONLY the WD SN850X, whose by-id path
    # can never resolve to the old Crucial P2, so the current system is safe.
    # It uses the disko pinned in flake.lock.
    #
    # A bootable image is intentionally not provided: the root pool uses a
    # prompted passphrase (keylocation=prompt), which cannot be set while
    # building an unattended image.
    apps.${system}.install-luctop-zfs = {
      type = "app";
      program = "${
        pkgs.writeShellApplication {
          name = "install-luctop-zfs";
          # zfs provides the zpool binary for the post-install pool export.
          runtimeInputs = [inputs.disko.packages.${system}.disko-install pkgs.zfs];
          text = ''
            set -euo pipefail

            disk=/dev/disk/by-id/nvme-WD_BLACK_SN850X_2000GB_25364G803949

            if [ ! -e "$disk" ]; then
              echo "error: new SSD not present at $disk" >&2
              exit 1
            fi

            echo "Installing luctop-zfs to $disk ($(readlink -f "$disk"))"
            echo "The old Crucial P2 is not touched by this command."

            # No exec: the pool export below must run in this same shell after
            # a successful install. "$@" passes disko-install flags through
            # (e.g. --dry-run).
            disko-install --flake .#luctop-zfs --disk main "$disk" "$@"

            # A dry-run builds and prints what would run; it must not touch
            # pool state, so stop here.
            for arg in "$@"; do
              case "$arg" in
                --dry-run)
                  echo "dry-run: skipping the post-install pool export."
                  exit 0
                  ;;
              esac
            done

            # disko-install leaves the freshly created zroot imported into the
            # *running* system's kernel session, and the pool's on-disk state
            # then says "last used by this system, not cleanly exported". The
            # new system's initrd imports with forceImportRoot=false (by
            # design, in hosts/luctop-zfs/zfs.nix) and refuses to take over
            # such a pool - observed as an endless "A start job is running
            # for import ZFS pool zroot" on the first boot. Exporting here
            # marks the pool cleanly exported, so every install hands off
            # deterministically. The guard also skips when a dry-run ran
            # against a session that still has an unrelated leftover pool
            # imported.
            if zpool list -H zroot >/dev/null 2>&1; then
              zpool export zroot
              echo "zroot exported cleanly; reboot and pick the WD in the firmware boot menu (F7/F12)."
            fi
          '';
        }
      }/bin/install-luctop-zfs";
    };

    nixosConfigurations = {
      # Laptop on the old Crucial P2 SSD (ext4). Production stays rebuildable
      # from this configuration until cutover.
      luctop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs mainUser stateVersion;
          hostname = "luctop";
        };
        modules = [
          ./hosts/luctop/configuration.nix
          inputs.procurator.nixosModules.x86_64-linux.procurator
          inputs.bandtrack.nixosModules.bandtrack
          inputs.maia.nixosModules.default
        ];
      };

      # Laptop on the new WD SN850X SSD (ZFS + disko). Experimental until the
      # old disk is retired.
      luctop-zfs = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs mainUser stateVersion;
          hostname = "luctop-zfs";
        };
        modules = [
          ./hosts/luctop-zfs/configuration.nix
          ./hosts/luctop-zfs/zfs.nix
          ./hosts/luctop-zfs/disko.nix
          inputs.disko.nixosModules.disko
          inputs.procurator.nixosModules.x86_64-linux.procurator
          inputs.bandtrack.nixosModules.bandtrack
          inputs.maia.nixosModules.default
        ];
      };

      # Currently the old laptop
      # nixos-rebuild switch --flake .#lucver --target-host lucver --sudo --ask-sudo-password
      lucver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs mainUser;
          stateVersion = "24.11";
          hostname = "lucver";
        };
        modules = [
          ./hosts/lucver/configuration.nix
          inputs.procurator.nixosModules.x86_64-linux.procurator
        ];
      };

      # Raspberry Pi 4 configuration
      # nixos-rebuild switch --flake .#raspi4 --target-host raspi --sudo
      # nix build .#nixosConfigurations.raspi4.config.system.build.sdImage
      raspi4 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          user = mainUser;
          hostname = "raspi4";
        };
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/raspi4/configuration.nix
        ];
      };
    };

    #Let's keep the same home manager config for the lucver and the luctop
    homeConfigurations = {
      ${mainUser} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };

        extraSpecialArgs = {
          inherit inputs mainUser stateVersion;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };

      "${mainUser}@lucver" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        extraSpecialArgs = {
          inherit inputs mainUser stateVersion;
        };
        modules = [./home-manager/lucver.nix];
      };

      # home-manager switch --flake .#lucas@raspi4 --target-host raspi --use-remote-sudo
      "${mainUser}@raspi4" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "aarch64-linux";};
        extraSpecialArgs = {
          inherit inputs;
          homeStateVersion = stateVersion;
          user = mainUser;
        };
        modules = [./home-manager/raspi4.nix];
      };
    };
  };
}
