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
  users.users.lucas.initialHashedPassword = "$y$j9T$fMB4.mcmYZ7XMrdvrjrYQ.$qJV4/su8c2yZhz17NpJT8QAW02cK9rIdRaJWB93rahA";

  # init_on_alloc zeroes every allocation as a hardening measure, but OpenZFS
  # documents that it "can lower ARC throughput considerably". This kernel
  # (7.2.6) is built with CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y and NixOS does not
  # override it, so turn it off to favor IO throughput. This trades away the
  # uninitialized-memory / use-after-free mitigation the option provides.
  # https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/Workload%20Tuning.html#init-on-alloc
  boot.kernelParams = ["init_on_alloc=0"];

  # Never let installs on the new ESP reorder the old system's NVRAM boot entry.
  # systemd-boot is installed on the currently mounted ESP, but firmware
  # variables keep the old disk as the default entry until cutover.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
