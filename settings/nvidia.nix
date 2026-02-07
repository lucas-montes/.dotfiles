{config, ...}: {
  nixpkgs.config.allowUnfree = true;
  hardware = {
    graphics.enable = true;
    nvidia-container-toolkit.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        amdgpuBusId = "PCI:6:0:0";
        #intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        sync.enable = false;
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };
  services.xserver.videoDrivers = ["nvidia"];
}
