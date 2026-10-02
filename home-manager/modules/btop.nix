{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override { rocmSupport = true; };
    settings = {
      update_ms = 100;
      shown_boxes = "cpu mem net proc gpu0";
      show_gpu_info = "On";
      shown_gpus = "amd";
    };
  };
}
