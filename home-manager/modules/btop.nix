{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {cudaSupport = true;}; # For NVIDIA GPUs
    # package = pkgs.btop;
    extraConfig = "update_ms = 100";
  };
}
