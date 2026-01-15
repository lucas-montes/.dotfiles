let
  shellAliases = import ./alias.nix;
in {
  programs = {
    nushell = {
      enable = true;
      extraConfig = builtins.readFile ./extraConfig.nu;
      inherit shellAliases;
    };
    carapace.enable = false;
    carapace.enableNushellIntegration = false;

    starship = {
      enable = true;
      settings = {
        add_newline = true;
      };
    };
  };
}
