{ config, pkgs, ... }: {
  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/var/lib/git-server";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJk9K6n6KDOI9dKTu9ocqKnBF29KVlOlIm413Ci4M8dU lucas@luctop"
    ];
  };

  users.groups.git = {};

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;        # Disable password login, use keys only
      PubkeyAuthentication = true;           # Allow public key authentication
      PermitRootLogin = "no";                # Never allow root SSH login
      X11Forwarding = false;                 # Disable X11 (not needed for server)
      AllowUsers = [ "lucas" "git" ];        # Only these users can SSH
      UseDns = false;                        # Speed up login, disable DNS lookup
    };
    extraConfig = ''
      Match user git
        AllowTcpForwarding no
        AllowAgentForwarding no
        PermitTTY no
        X11Forwarding no
    '';
  };

}
