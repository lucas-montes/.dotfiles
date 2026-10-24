{
  description = "Java development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forEachSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              jdk21
              maven
              # IntelliJ IDEA unified build (free Community features built-in,
              # Ultimate features via subscription). Successor of idea-community.
              # See: https://blog.jetbrains.com/idea/2025/07/intellij-idea-unified-distribution-plan/
              jetbrains.idea
              # Uncomment what you need:
              # gradle
            ];

            JAVA_HOME = "${pkgs.jdk21.home}";

            shellHook = ''
              export JAVA_HOME="${pkgs.jdk21.home}"
              echo "Java: $(java -version 2>&1 | head -n 1)"
              echo "JAVA_HOME=$JAVA_HOME"
            '';
          };
        });
    };
}
