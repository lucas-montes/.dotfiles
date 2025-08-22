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

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    homeStateVersion = "24.11";
    user = "lucas";
    pkgs = import nixpkgs {
      inherit system;
    };
    hosts = [
      {
        hostname = "luctop";
        stateVersion = "24.11";
      }
    ];

    makeSystem = {
      hostname,
      stateVersion,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs stateVersion hostname user;
        };

        modules = [
          ./hosts/${hostname}/configuration.nix
        ];
      };
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

    nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
      configs
      // {
        "${host.hostname}" = makeSystem {
          inherit (host) hostname stateVersion;
        };
      }) {}
    hosts;

    homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs homeStateVersion user;
      };
      modules = [
        ./home-manager/home.nix
      ];
    };
  };
}
