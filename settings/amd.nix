{
  pkgs,
  ...
}: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
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

  # ollama is installed via `nix profile`, not declared here, and already
  # bundles its own complete ROCm runtime (its own rocm-runtime, rocm-comgr,
  # even its own clang/llvm) -- it never reaches into this module's
  # packages. HSA_OVERRIDE_GFX_VERSION is the one thing it still needs from
  # the system, since the GPU-model override has to be ambient wherever it
  # runs. The HIP/ROCm *development* toolchain (hipcc, rocblas, rocfft,
  # rocsolver, rocsparse, /opt/rocm, ROCM_PATH) that used to live here was
  # dropped -- add it to a project's own flake devShell if that project
  # needs to compile HIP code or link those math libs.
  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "11.5.0";
  };

  # Add user to render and video groups for GPU access
  users.users.lucas.extraGroups = ["render" "video"];
}
