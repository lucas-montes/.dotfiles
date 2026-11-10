{
  pkgs,
  inputs,
  ...
}: {
  programs.claude-code = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    settings = {
      includeCoAuthoredBy = false;
      worktree = {
        bgIsolation = "none";
      };
    };
  };
}
