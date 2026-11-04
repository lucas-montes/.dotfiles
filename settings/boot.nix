{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Without a cap, a boot entry is kept for every generation nix.gc hasn't
  # collected yet, and nothing currently bounds that count. The ESP has room
  # to spare today, but this keeps it that way instead of finding out later.
  boot.loader.systemd-boot.configurationLimit = 10;
}
