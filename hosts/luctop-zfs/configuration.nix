{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../luctop/common.nix
    ./hardware-configuration.nix
  ];

  # Pinned to the newest kernel known to work with this flake's ZFS release.
  # linuxPackages_latest can move past ZFS's supported kernel range and break evaluation.
  boot.kernelPackages = pkgs.linuxPackages_7_2;

  # Never let installs on the new ESP reorder the old system's NVRAM boot entry.
  # systemd-boot is installed on the currently mounted ESP, but firmware
  # variables keep the old disk as the default entry until cutover.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
