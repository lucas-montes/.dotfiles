{config, pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clang
        rocmPackages.hipcc
        rocmPackages.rocm-core
        rocmPackages.rocm-runtime
        rocmPackages.rocm-device-libs
        rocmPackages.rocm-comgr
        rocmPackages.rocm-smi
        rocmPackages.rocsparse
        rocmPackages.rocblas
        rocmPackages.rocfft
        rocmPackages.rocsolver
        amdvlk
        vulkan-loader
        vulkan-validation-layers
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vulkan-loader
        amdvlk
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    rocm-smi
    clinfo
  ];

  # Add user to render and video groups for GPU access
  users.users.lucas.extraGroups = ["render" "video"];
}
