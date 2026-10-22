{pkgs, ...}: {
  # Required by ZFS. Keep this stable for zroot on the new SSD.
  networking.hostId = "3de266ad";

  boot = {
    # Cap ARC below ZFS's 50%-of-RAM default. This host already uses 30G RAM
    # heavily and runs zram at 100% of memory.
    #
    # metaslab_lba_weighting_enabled=0 disables LBA-weighted metaslab selection,
    # which is only meaningful for spinning disks; this pool is SSD-only. It
    # reduces allocator CPU and lets the allocator keep ~5% free instead of the
    # usual ~10% before falling back to the slow best-fit strategy.
    # https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/Workload%20Tuning.html#metaslab-allocator
    # https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/Workload%20Tuning.html#free-space
    extraModprobeConfig = "options zfs zfs_arc_max=8589934592 metaslab_lba_weighting_enabled=0";
    supportedFilesystems = ["zfs"];
    initrd.supportedFilesystems = ["zfs"];
    zfs = {
      # Do not bypass ZFS's pool-import protection by default.
      # After an unclean shutdown, boot once with the zfs_force=1 kernel parameter if needed.
      forceImportRoot = false;
      package = pkgs.zfs;
      requestEncryptionCredentials = true;
    };
  };

  services.zfs = {
    # Prefer the pool's continuous autotrim (set on zroot in disko.nix) over the
    # periodic `zpool trim` that this option schedules. The two are separate
    # mechanisms and running both is redundant.
    # https://wiki.nixos.org/wiki/ZFS#Auto_ZFS_trimming
    trim.enable = false;
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    # Snapshots are strictly opt-in via the com.sun:auto-snapshot properties.
    # Only root/home/Documents opts in, and only for the weekly cadence, so the
    # other timers fire but find nothing to snapshot. --utc keeps snapshot names
    # monotonic across DST and timezone changes.
    # https://search.nixos.org/options?show=services.zfs.autoSnapshot
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
      weekly = 4;
    };
  };

  # disko generates these filesystems; mark the early-boot requirements here.
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  # Documents/Downloads/Games/.cache are separate datasets mounted over their
  # directories, so disko creates each mount root as root:root. The rest of
  # /home/lucas belongs to lucas:users (the isNormalUser group, gid 100), so
  # give these the same ownership or apps and home-manager cannot write into
  # them. The names are resolved at boot, after the user has been created.
  systemd.tmpfiles.rules = [
    "d /home/lucas/Documents 0755 lucas users - -"
    "d /home/lucas/Downloads 0755 lucas users - -"
    "d /home/lucas/Games 0755 lucas users - -"
    "d /home/lucas/.cache 0700 lucas users - -"
  ];
}
