{
  pkgs,
  inputs,
  ...
}: let
  opencode2 = inputs.opencode.packages.${pkgs.system}.opencode2;
  # numtide's llm-agents.nix ships OpenCode 2 as "opencode2"; keep the plain
  # "opencode" command name as a symlinked wrapper.
  opencode2Wrapped = pkgs.symlinkJoin {
    name = "opencode";
    paths = [opencode2];
    postBuild = "ln -s ${opencode2}/bin/opencode2 $out/bin/opencode";
  };
  opencodeConfig = {
    provider = {
      ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "ollama";
        options = {
          baseURL = "http://127.0.0.1:11434/v1/";
          apiKey = "test";
        };
        models = {
          "qwen2.5-coder:14b" = {
            name = "qwen2.5-coder:14b";
            limit = {
              context = 1000000;
              output = 131072;
            };
          };
        };
      };
    };
  };
in {
  programs.opencode = {
    package = opencode2Wrapped;
    enable = true;
    settings = opencodeConfig;
    agents = {
      oracle = ./agents/Oracle.md;
    };
  };
}
