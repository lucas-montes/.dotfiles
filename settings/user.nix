{
  pkgs,
  mainUser,
  ...
}: {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.nushell;
    users.${mainUser} = {
      isNormalUser = true;
      description = "lucas";
      extraGroups = ["networkmanager" "wheel" "docker" "dialout" "disk" "kvm"];
    };
  };

  services.getty.autologinUser = mainUser;
}
