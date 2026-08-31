{
  # networking.nameservers = [ "127.0.0.1" ];
  services.procurator = {
    # Enable and configure the VMM host networking and worker service
    vmm = {
      enable = true;
      dnsWildcardDomain = "worker.local";
      externalInterface = "wlp98s0";
    };
    worker = {
      enable = false;
    };
  };
}
