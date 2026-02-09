{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # Audio issue with latest amd https://github.com/NixOS/nixos-hardware/issues/1603
    wireplumber.extraConfig.no-ucm = {
      "monitor.alsa.properties" = {
        "alsa.use-ucm" = false;
      };
    };
  };
}
