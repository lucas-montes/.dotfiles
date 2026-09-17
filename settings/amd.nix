{
  config,
  pkgs,
  ...
}: {
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
        vulkan-loader
        vulkan-validation-layers
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vulkan-loader
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    clinfo
  ];

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm - - - - ${pkgs.rocmPackages.clr}"
  ];

  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "11.5.0";
    ROCM_PATH = "${pkgs.rocmPackages.clr}";
  };

  # Add user to render and video groups for GPU access
  users.users.lucas.extraGroups = ["render" "video"];
}
