{
  programs = let
    name = "Lucas";
    email = "lluc23@hotmail.com";
  in {
    git = {
      enable = true;
      settings = {
        user = {
          name = name;
          email = email;
        };
        push = {
          autoSetupRemote = true;
        };
        fetch = {
          prune = true;
        };
        pull = {
          rebase = true;
        };
      };
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
    jujutsu = {
      enable = true;
      settings = {
        user = {
          inherit email name;
        };
      };
    };
  };
}
