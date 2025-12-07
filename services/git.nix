{pkgs, ...}: let
gitServerPath = "/var/lib/git-server";
# TO make it executable
postReceiveHook = pkgs.writeScript "post-receive" (builtins.readFile ./post-receive);
# Create git config file the same way as the hook
gitConfig = pkgs.writeText "gitconfig" ''
  [core]
      hooksPath = ${gitServerPath}/hooks
  [safe]
      directory = *
'';
in {
  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = gitServerPath;
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJk9K6n6KDOI9dKTu9ocqKnBF29KVlOlIm413Ci4M8dU lucas@luctop"
    ];
  };

  users.groups.git = {};
  users.users.lucas.extraGroups = ["git"];

  # Define filesystem structure and permissions using systemd-tmpfiles
  systemd.tmpfiles.rules = [
    # Create hooks directory with read/execute permissions for git user/group
    "d ${gitServerPath}/hooks 755 git git - -"

    # Create symlink from hooks directory to the actual post-receive script
    # L = create symlink, target is the script created by pkgs.writeScript
    "L ${gitServerPath}/hooks/post-receive - - - - ${postReceiveHook}"

    # Create symlink to git config file for the git user
    # L = create symlink, target is the config file created by pkgs.writeText
    "L ${gitServerPath}/.gitconfig - - - - ${gitConfig}"

    # Z = recursively fix ownership/permissions of git server directory
    # 2775 = rwxrwsr-x (owner: rwx, group: rws, other: r-x, setgid bit set)
    # setgid ensures new files inherit the git group
    "Z ${gitServerPath} 2775 git git - -"
  ];

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false; # Disable password login, use keys only
      PubkeyAuthentication = true; # Allow public key authentication
      PermitRootLogin = "no"; # Never allow root SSH login
      X11Forwarding = false; # Disable X11 (not needed for server)
      AllowUsers = ["lucas" "git"]; # Only these users can SSH
      UseDns = false; # Speed up login, disable DNS lookup
      MaxAuthTries = 3;  # Rate limit auth attempts
      ClientAliveInterval = 60;  # Keep connections alive
    };
    extraConfig = ''
      Match user git
        AllowTcpForwarding no
        AllowAgentForwarding no
        PermitTTY no
        X11Forwarding no
        GatewayPorts no
    '';
  };
}
