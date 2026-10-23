{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./common.nix
  ];

  # latest kernel to try to avoid errors with AMD Radeon 890M gpu
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # temporary to be able to create the pools and all
  networking.hostId = "a1b2c3d4"; # unique, temporary
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.package = pkgs.zfs;
  boot.zfs.forceImportRoot = false;
}
