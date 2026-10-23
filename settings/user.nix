{
  pkgs,
  mainUser,
  ...
}: {
  users = {
    defaultUserShell = pkgs.nushell;
    users.${mainUser} = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJk9K6n6KDOI9dKTu9ocqKnBF29KVlOlIm413Ci4M8dU lucas@luctop"
      ];
      isNormalUser = true;
      initialHashedPassword = "$y$j9T$fMB4.mcmYZ7XMrdvrjrYQ.$qJV4/su8c2yZhz17NpJT8QAW02cK9rIdRaJWB93rahA";
      description = "lucas";
      extraGroups = ["networkmanager" "wheel" "docker" "dialout" "disk" "kvm"];
    };
  };

  services.getty.autologinUser = mainUser;
}
