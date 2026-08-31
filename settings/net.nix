{ lib, ... }: {
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  networking.networkmanager.unmanaged = ["interface-name:br0"];
  networking.useDHCP = lib.mkForce false;
  networking.dhcpcd.enable = lib.mkForce false;
  services.resolved.enable = true;
}
