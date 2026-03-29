{
  services.procurator = {
    # Enable and configure the VMM host networking and worker service
    vmm = {
      enable = true;
      externalInterface = "wlp98s0"; # set to your host uplink
      bridgeAddress = "192.168.100.1";
    };
    worker = {
      enable = false;
    };
  };
}
