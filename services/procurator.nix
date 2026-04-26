{
  services.procurator = {
    # Enable and configure the VMM host networking and worker service
    vmm = {
      enable = true;
      externalInterface = "wlp98s0";
    };
    worker = {
      enable = false;
    };
  };
}
