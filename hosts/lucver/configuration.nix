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
    ../../services/procurator.nix
  ];

  environment.systemPackages = [pkgs.home-manager pkgs.curl pkgs.git pkgs.cudatoolkit];

  networking.hostName = "lucver";

  services = {
    # Enable Avahi to reach it as lucver.local
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };

    # Prevent suspend when laptop lid is closed (server mode)
    logind.settings.Login = {
      HandleLidSwitch = "ignore";              # Lid closed on battery
      HandleLidSwitchExternalPower = "ignore"; # Lid closed on AC
      HandleLidSwitchDocked = "ignore";        # Lid closed while docked
      # Also ignore power/suspend keys to avoid accidental shutdowns
      HandlePowerKey = "ignore";
      HandleSuspendKey = "ignore";
    };

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

  # Disable all sleep/suspend/hibernate targets
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    "hybrid-sleep".enable = false;
  };

  # Keep system responsive on AC; avoid auto-suspend from power management
  powerManagement = {
    enable = true;
    powertop.enable = false;
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
