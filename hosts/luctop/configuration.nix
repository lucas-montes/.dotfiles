{
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./common.nix
  ];

  # latest kernel to try to avoid errors with AMD Radeon 890M gpu
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
