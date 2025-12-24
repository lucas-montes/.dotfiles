{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    TERMINAL = "ghostty";
    EDITOR = "nvim";

    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "vulkan";
  };
}
