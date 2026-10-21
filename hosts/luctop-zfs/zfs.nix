{pkgs, ...}: {
  # Required by ZFS. Keep this stable for zroot on the new SSD.
  networking.hostId = "3de266ad";

  boot.supportedFilesystems = ["zfs"];
  boot.initrd.supportedFilesystems = ["zfs"];
  boot.zfs.package = pkgs.zfs;
  boot.zfs.requestEncryptionCredentials = true;

  # Do not bypass ZFS's pool-import protection by default.
  # After an unclean shutdown, boot once with the zfs_force=1 kernel parameter if needed.
  boot.zfs.forceImportRoot = false;

  # Cap ARC below ZFS's 50%-of-RAM default. This host already uses 30G RAM
  # heavily and runs zram at 100% of memory.
  boot.extraModprobeConfig = "options zfs zfs_arc_max=8589934592";

  services.zfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };
  services.zfs.trim.enable = true;

  # disko generates these filesystems; mark the early-boot requirements here.
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
