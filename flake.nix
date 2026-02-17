{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nvf = {url = "github:notashelf/nvf";};

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {url = "github:NixOS/nixos-hardware/master";};
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    mainUser = "lucas";
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

    nixosConfigurations = {
      # Laptop configuration currently the tuxedo
      luctop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs mainUser;
          stateVersion = "25.05";
          hostname = "luctop";
        };
        modules = [
          ./hosts/luctop/configuration.nix
          # nixos-hardware.nixosModules.common-cpu-amd
          # nixos-hardware.nixosModules.common-cpu-amd-pstate
          # nixos-hardware.nixosModules.common-gpu-amd
          ];
      };

      # Currently the old laptop
      lucver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs mainUser;
          stateVersion = "24.11";
          hostname = "lucver";
        };
        modules = [./hosts/lucver/configuration.nix];
      };

      # Raspberry Pi 4 configuration
      # nixos-rebuild switch --flake .#raspi4 --target-host raspi --use-remote-sudo
      # nix build .#nixosConfigurations.raspi4.config.system.build.sdImage
      raspi4 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          user = mainUser;
          hostname = "raspi4";
        };
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/raspi4/configuration.nix
        ];
      };
    };

    #Let's keep the same home manager config for the lucver and the luctop
    homeConfigurations = {
      ${mainUser} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        extraSpecialArgs = {
          inherit inputs mainUser;
          stateVersion = "25.05";
        };
        modules = [./home-manager/home.nix];
      };

      "${mainUser}@lucver" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        extraSpecialArgs = {
          inherit inputs mainUser;
          stateVersion = "25.05";
        };
        modules = [./home-manager/lucver.nix];
      };

      # home-manager switch --flake .#lucas@raspi4 --target-host raspi --use-remote-sudo
      "${mainUser}@raspi4" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "aarch64-linux";};
        extraSpecialArgs = {
          homeStateVersion = "25.05";
          inherit inputs;
          user = mainUser;
        };
        modules = [./home-manager/raspi4.nix];
      };
    };
  };
}
