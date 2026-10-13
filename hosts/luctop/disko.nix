{ ... }:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_2000GB_25364G803949";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
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
      options.ashift = "12";
      rootFsOptions = {
        canmount = "off";
        mountpoint = "none";
        compression = "zstd";
        acltype = "posixacl";
        xattr = "sa";
      };
      datasets = {
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
        "root/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = {
            recordsize = "1M";
            atime = "off";
          };
        };
        "root/home" = {
          type = "zfs_fs";
          mountpoint = "/home";
          options = {
            recordsize = "64K";
            atime = "off";
          };
        };
        "root/var-log" = {
          type = "zfs_fs";
          mountpoint = "/var/log";
          options = {
            recordsize = "128K";
            atime = "off";
          };
        };
        "root/persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
          options = {
            atime = "off";
          };
        };
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
