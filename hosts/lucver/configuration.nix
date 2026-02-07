{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../settings
    ../../settings/nvidia.nix
    ../../services/postgres.nix
    ../../services/procurator
  ];

  environment.systemPackages = [pkgs.home-manager pkgs.curl pkgs.git pkgs.cudatoolkit];

  networking.hostName = "lucver";

  services = {
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false; # Disable password login, use keys only
        PubkeyAuthentication = true; # Allow public key authentication
        PermitRootLogin = "no"; # Never allow root SSH login
        X11Forwarding = false; # Disable X11 (not needed for server)
        AllowUsers = ["lucas" "git"]; # Only these users can SSH
        UseDns = false; # Speed up login, disable DNS lookup
        MaxAuthTries = 3; # Rate limit auth attempts
        ClientAliveInterval = 60; # Keep connections alive
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
    xserver.xkb = {
      layout = "latam";
      variant = "";
    };
    gnome.gnome-keyring = {enable = true;};
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    nix-ld.enable = true;
    seahorse.enable = true;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = stateVersion;
}
