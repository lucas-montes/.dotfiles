{
  pkgs,
  user,
  ...
}: {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.nushell;
    users.${user} = {
      isNormalUser = true;
      description = "lucas";
      extraGroups = ["networkmanager" "wheel" "docker" "dialout" "disk" "kvm"];
    };
  };

  services.getty.autologinUser = user;
}
