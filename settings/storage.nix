{
  services.gvfs.enable = true; # For nautilus to use trash
  services.tumbler.enable = true; # For preview images
  services.udisks2.enable = true;
  #fileSystems."/data" = {
  #  device = "/dev/disk/by-label/SSD-1TB";
  #  fsType = "vfat";
  #  options = ["defaults" "user" "rw" "utf8" "umask=000"];
  #};
}
