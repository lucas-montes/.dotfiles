{
  pkgs,
  user,
  ...
}: {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.nushell;
    users.${user} = {
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJk9K6n6KDOI9dKTu9ocqKnBF29KVlOlIm413Ci4M8dU lucas@luctop"];
      isNormalUser = true;
      description = "lucas";
      extraGroups = ["networkmanager" "wheel" "docker" "dialout" "disk" "kvm"];
    };
  };

  services.getty.autologinUser = user;
}
