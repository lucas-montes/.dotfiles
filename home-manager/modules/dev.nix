{
  programs = {
    envman = {
      enable = false;
    };
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
