{
  lib,
  pkgs,
  ...
}: {
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.networkmanager.unmanaged = ["interface-name:br0"];
  networking.useDHCP = lib.mkForce false;
  networking.dhcpcd.enable = lib.mkForce false;
  services.resolved.enable = lib.mkForce false;

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = lib.mkForce false;
    settings = {
      cache-size = 10000;
      addn-hosts = "${pkgs.stevenblack-blocklist}/hosts";
      domain-needed = true;
      bogus-priv = true;
    };
  };

  networking.nameservers = lib.mkForce ["127.0.0.1"];
}
