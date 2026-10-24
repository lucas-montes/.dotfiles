{
  description = "erproxy — egress proxy on BEAM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        serverWrapper = pkgs.writeShellApplication {
          name = "erproxy-server-wrapper";
          runtimeInputs = with pkgs; [erlang rebar3 python3];
          text = builtins.readFile ./scripts/erproxy-server-wrapper.sh;
        };
        serverLauncher = pkgs.writeShellScript "erproxy-server" ''
          echo "=== erproxy server ==="
          echo "  Control  :9999   HTTP  :8888   SOCKS5 :1080"
          echo "  Fetch    :8080   Admin :9090"
          echo ""
          echo "  Agent: nix run .#agent -- . --port 9999 --device-id d1 --country de --city berlin"
          export ERPROXY_DEV_CONFIG="${./config/dev.config}"
          exec ${serverWrapper}/bin/erproxy-server-wrapper "$@"
        '';
        # Add wrapper to packages for direct access
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            erlang-language-platform
            erlang
            rebar3
            python3
            erlfmt
          ];
        };

        apps = {
          compile = {
            type = "app";
            program = "${pkgs.writeShellScript "erproxy-compile" ''
              set -euo pipefail
              rebar3 compile
              echo "=== Compilation done ==="
            ''}";
          };

          test = {
            type = "app";
            program = "${pkgs.writeShellScript "erproxy-test" ''
              set -euo pipefail
              rebar3 ct
              echo "=== All tests passed ==="
            ''}";
          };

          server = {
            type = "app";
            program = "${serverLauncher}";
          };

        };
      }
    );
}
