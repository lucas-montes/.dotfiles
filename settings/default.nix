{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./env.nix
    ./fonts.nix
    ./home-manager.nix
    ./hyprland.nix
    ./locale.nix
    ./net.nix
    ./nix.nix
    ./storage.nix
    ./user.nix
    ./zram.nix
  ];

  # GPU-specific modules (amd.nix, nvidia.nix) are imported per-host, not
  # here, since the two hosts sharing this file have different GPUs.
  nixpkgs.config.allowUnfree = true;
}
