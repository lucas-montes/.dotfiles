{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override { cudaSupport = true; }; # For AMD GPUs
    extraConfig = "update_ms = 100";
  };
}
