{ pkgs, inputs, ... }: let
  opencodeConfig = {
    provider = {
      ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "ollama";
        options = {
          baseURL = "http://127.0.0.1:11434/v1/chat/completions";
          apiKey = "test";
        };
        models = {
          "qwen2.5-coder:14b" = {
            name = "qwen2.5-coder:14b";
            limit = { context = 1000000; output = 131072; };
          };
        };
      };
    };
  };
in {
  programs.opencode = {
    package = inputs.opencode.packages.${pkgs.system}.default;
    enable = true;
    settings = opencodeConfig;
    agents = {
      oracle = ./agents/Oracle.md;
    };
  };
}
