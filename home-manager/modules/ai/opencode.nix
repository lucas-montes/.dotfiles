let
  opencodeConfig = {
    # instructions = [ "./AGENTS.md" ];
    # mcp = {
    #   fff = {
    #     type = "local";
    #     command = [ "${fffMcp}/bin/fff-mcp" ];
    #     enabled = true;
    #   };
    # };
    provider = {
      CrofAI = {
        npm = "@ai-sdk/openai-compatible";
        name = "CrofAI";
        options = {
          baseURL = "https://crof.ai/v1";

        };
        models = {
          "deepseek-v4-flash" = {
            name = "CrofAI: deepseek-v4-flash";
            limit = { context = 1000000; output = 131072; };
          };
          "deepseek-v4-pro" = {
            name = "CrofAI: deepseek-v4-pro";
            limit = { context = 1000000; output = 131072; };
          };
          "glm-5.1" = {
            name = "CrofAI: glm-5.1";
            limit = { context = 202752; output = 202752; };
          };
          "glm-5.1-precision" = {
            name = "CrofAI: glm-5.1-precision";
            limit = { context = 202752; output = 202752; };
          };
        };
      };
    };
  };

in{
  programs.opencode = {
      enable = true;
      settings = opencodeConfig;
      agents = {
        oracle = ./agents/Oracle.md;
      };
  };
}
