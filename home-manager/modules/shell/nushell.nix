let shellAliases = import ./alias.nix;
in {
  programs = {
    nushell = {
      enable = true;
      extraConfig = builtins.readFile ./extraConfig.nu;
      inherit shellAliases;
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      settings = { add_newline = true; };
    };
  };
}
