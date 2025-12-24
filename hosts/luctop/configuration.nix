{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../settings
  ];

    nixpkgs.config.allowUnfree = true;

boot.kernelModules = [ "amdgpu" ];
hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr.icd
      ];
    };
  };

# Enable the integrated graphics (for an APU like the Ryzen)
services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = [
    pkgs.home-manager
    pkgs.curl
    pkgs.wget
    pkgs.git
    pkgs.clinfo
    pkgs.vulkan-tools
  ];

  networking.hostName = "luctop";

  services = {
    printing.enable = true;
    xserver.xkb = {
      layout = "us";
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
  # Files, browser, screen sharing stuff
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  system.stateVersion = stateVersion;
}
