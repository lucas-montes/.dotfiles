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
      options = {
        # ashift 12 matches this NVMe drive's 4K sectors. This is a
        # pool-creation decision; it cannot be changed later without
        # recreating the pool.
        ashift = "12";
        # autotrim issues TRIM continuously as blocks are freed, avoiding the
        # latency burst of a periodic `zpool trim` (which is disabled in
        # zfs.nix). https://openzfs.github.io/openzfs-docs/man/master/7/zpoolprops.7.html#autotrim
        autotrim = "on";
      };
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
        # dnodesize=auto grows a file's dnode only as needed, letting small
        # files and their xattrs live inline (embedded data) and cutting
        # metadata IO. Pairs with xattr=sa and auto-enables large_dnode.
        # https://openzfs.github.io/openzfs-docs/man/master/7/zfsprops.7.html#dnodesize
        dnodesize = "auto";
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
            # Treat synchronous writes as olog-less: coalesce them through the
            # normal TXG instead of committing each to the ZIL. Correct for
            # workloads that do not need per-write durability (e.g. app state).
            logbias = "throughput";
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
            # The store is reproducible, so a power loss that drops the last
            # writes is recoverable; sync=disabled skips ZIL writes entirely.
            # logbias=throughput keeps those writes batching through the TXG.
            logbias = "throughput";
            sync = "disabled";
          };
        };
        # Documents and configuration are dominated by smaller files, so use a
        # smaller record size than /nix. This is the dataset the selective
        # restic backups and the weekly snapshots are expected to cover.
        "root/home" = {
          type = "zfs_fs";
          mountpoint = "/home";
          options = {
            recordsize = "128K";
            atime = "off";
          };
        };
        # The datasets below are mounted over existing home subdirectories, so
        # disko owns each mount root; zfs.nix takes care of giving them
        # lucas:users via systemd.tmpfiles. They stay atime=off as the pool is
        # never read for its access times.
        #
        # Documents is the only dataset with snapshots enabled. The base
        # com.sun:auto-snapshot property stays unset (opt-out), and only the
        # weekly cadence is turned on, so just the weekly timer creates them.
        "root/home/Documents" = {
          type = "zfs_fs";
          mountpoint = "/home/lucas/Documents";
          options = {
            recordsize = "128K";
            atime = "off";
            "com.sun:auto-snapshot:weekly" = "true";
          };
        };
        # Downloads hold large, few-files reads/writes where a 1M
        # record size maximizes sequential throughput.
        "root/home/Downloads" = {
          type = "zfs_fs";
          mountpoint = "/home/lucas/Downloads";
          options = {
            recordsize = "1M";
            atime = "off";
          };
        };
        # .cache is disposable build/app cache: sync=disabled avoids ZIL writes
        # for a filesystem we are happy to lose, and the refquota keeps it from
        # eating the pool (it only bounds data, not snapshots).
        # https://openzfs.github.io/openzfs-docs/man/master/7/zfsprops.7.html#refquota
        "root/home/.cache" = {
          type = "zfs_fs";
          mountpoint = "/home/lucas/.cache";
          options = {
            recordsize = "128K";
            atime = "off";
            sync = "disabled";
            refquota = "20G";
            "com.sun:auto-snapshot" = "false";
          };
        };
        # Keep logs separate so log growth, pruning, or a log-focused rollback
        # does not affect the root filesystem. A separate dataset also makes
        # the early-boot dependency explicit in the host configuration.
        "root/var-log" = {
          type = "zfs_fs";
          mountpoint = "/var/log";
          options = {
            recordsize = "1M";
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
