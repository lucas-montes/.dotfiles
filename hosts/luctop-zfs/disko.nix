{...}: {
  # New-SSD-only layout. Do not run this against the old Crucial drive.
  #
  # The pinned by-id path follows the WD SN850X even when kernel
  # enumeration flips it between nvme0 and nvme1. That observed instability
  # is why a bare /dev/nvmeXnY name would be unsafe here.
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_2000GB_25364G803949";
      content = {
        type = "gpt";
        partitions = {
          # A full 1G ESP leaves comfortable room for several systemd-boot
          # generations instead of using the tiny size from disko's tests.
          # It stays VFAT and unencrypted because the firmware and bootloader
          # must be able to read it before ZFS is unlocked.
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          # The remaining space goes to ZFS because swap is a zvol inside the
          # pool rather than a separate partition. There is intentionally no
          # mirror: the old 1TB disk has a different size and stays independent.
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };

    zpool.zroot = {
      type = "zpool";
      # ashift 12 matches this NVMe drive's 4K sectors. This is a pool-creation
      # decision; it cannot be changed later without recreating the pool.
      options.ashift = "12";
      # Snapshot the installed root before the first NixOS installation, while
      # it is still empty. The guard keeps reruns idempotent instead of
      # failing if the snapshot already exists.
      postCreateHook = ''
        if ! zfs list -H -o name -t snapshot | grep -qx "zroot/root@blank"; then
          zfs snapshot zroot/root@blank
        fi
      '';
      # Keep the pool root itself unmounted and non-automatic. These options
      # establish the normal defaults inherited by the installation datasets.
      # zstd-3 is explicit here so the store's compression behavior is pinned
      # rather than depending on an implementation-defined zstd default.
      rootFsOptions = {
        canmount = "off";
        mountpoint = "none";
        compression = "zstd-3";
        acltype = "posixacl";
        xattr = "sa";
      };
      datasets = {
        # Encrypt the installed root directly with ZFS instead of adding LUKS.
        # Children inherit this encryption, so nested datasets do not repeat it.
        # The 128K record size is a general-purpose compromise for /etc, /var,
        # and other small mixed files outside the tuned datasets below.
        "root" = {
          type = "zfs_fs";
          mountpoint = "/";
          options = {
            encryption = "aes-256-gcm";
            keyformat = "passphrase";
            keylocation = "prompt";
            recordsize = "128K";
            atime = "off";
          };
        };
        # A large record size lets zstd compress across the many relatively
        # small Nix store files packed into each block, at the cost of more
        # read amplification for random access. That tradeoff favors the mostly
        # read-only store.
        "root/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = {
            recordsize = "1M";
            atime = "off";
          };
        };
        # Documents and configuration are dominated by smaller files, so use a
        # smaller record size than /nix. This is the dataset selective restic
        # backups are expected to cover.
        "root/home" = {
          type = "zfs_fs";
          mountpoint = "/home";
          options = {
            recordsize = "64K";
            atime = "off";
          };
        };
        # Keep logs separate so log growth, pruning, or a log-focused rollback
        # does not affect the root filesystem. A separate dataset also makes
        # the early-boot dependency explicit in the host configuration.
        "root/var-log" = {
          type = "zfs_fs";
          mountpoint = "/var/log";
          options = {
            recordsize = "128K";
            atime = "off";
          };
        };
        # Reserve a location for machine-specific state that should survive a
        # root rollback but does not belong in the Nix store or user home.
        "root/persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
          options = {
            atime = "off";
          };
        };
        # 16G is a cold safety net alongside zram, not hibernation storage:
        # NixOS disables hibernation for ZFS by default. The volume inherits
        # the pool's encryption and avoids caching swap pages in ARC.
        "root/swap" = {
          type = "zfs_volume";
          size = "16G";
          content = {
            type = "swap";
          };
          options = {
            volblocksize = "4096";
            compression = "zle";
            logbias = "throughput";
            sync = "always";
            primarycache = "metadata";
            secondarycache = "none";
            "com.sun:auto-snapshot" = "false";
          };
        };
      };
    };
  };
}
