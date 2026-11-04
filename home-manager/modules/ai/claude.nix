{
  programs.claude-code = {
    enable = true;
    settings = {
      includeCoAuthoredBy = false;
      worktree = {
        bgIsolation = "none";
      };
    };
  };
}
