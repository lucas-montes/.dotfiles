{
  description = "Android + Kotlin development environment using flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };

        androidPkgs = pkgs.androidenv.composeAndroidPackages {
          platformVersions = [ "34" ];
          buildToolsVersions = [ "34.0.0" ];
          includeNDK = true;
          ndkVersions = [ "25.2.9519653" ];
          useGoogleAPIs = false;
          includeEmulator = false;
        };

        androidSdk = androidPkgs.androidsdk;
      in {
        devShells.default = pkgs.mkShell {
          name = "android-kotlin-dev-shell";

          packages = with pkgs; [
            androidSdk
            android-studio
            openjdk
            gradle
            kotlin
            git
          ];

          JAVA_HOME = "${pkgs.openjdk}/lib/openjdk";
        };
      });
}
