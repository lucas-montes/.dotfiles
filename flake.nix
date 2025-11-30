{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
    };

    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    tuxedo-nixos,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    stateVersion = "25.05";
    mainUser = "lucas";
    pkgs = import nixpkgs { inherit system; };

  in {
    # Used by `nix flake init -t <flake>#<name>`
    templates."rust" = {
      path = ./templates/rust;
      description = "Template for a rust project";
      welcomeText = ''
        # Getting Started
        - run `direnv allow` to enter the development environment
      '';
    };

    templates."python" = {
      path = ./templates/python;
      description = "Template for python project";
      welcomeText = ''
        # Getting Started
        - run `direnv allow` to enter the development environment
      '';
    };

    # nixosConfigurations = nixpkgs.lib.mapAttrs mkNixosConfig hosts;

    nixosConfigurations.luctop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs stateVersion mainUser; };
        modules = [ ./hosts/luctop/configuration.nix ];
      };

      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs stateVersion mainUser; };
        modules = [
          ./hosts/server/configuration.nix
          tuxedo-nixos.nixosModules.default
        ];
      };

    homeConfigurations.${mainUser} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs stateVersion mainUser;
      };
      modules = [
        ./home-manager/home.nix
      ];
    };
  };
}
