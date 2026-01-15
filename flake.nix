{
  description = "My system configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    user = "lucas";
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
      # Laptop configuration
      luctop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs user;
          stateVersion = "24.11";
          hostname = "luctop";
        };
        modules = [
          ./hosts/luctop/configuration.nix
        ];
      };

      # Raspberry Pi 4 configuration
      # nixos-rebuild switch --flake .#raspi4 --target-host raspi --use-remote-sudo
      # nix build .#nixosConfigurations.raspi4.config.system.build.sdImage
      raspi4 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit user;
          hostname = "raspi4";
        };
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/raspi4/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      ${user} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
        extraSpecialArgs = {
          inherit inputs user;
          homeStateVersion = "24.11";
        };
        modules = [
          ./home-manager/home.nix
        ];
      };

      # home-manager switch --flake .#lucas@raspi4 --target-host raspi --use-remote-sudo
      "${user}@raspi4" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
        };
        extraSpecialArgs = {
          homeStateVersion = "25.05";
          inherit inputs user;
        };
        modules = [
          ./home-manager/raspi4.nix
        ];
      };
    };
  };
}
