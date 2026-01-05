{pkgs, ...}: {
  programs = {
        # Firefox to use with the Web-eid app seems easier than Chromium https://wiki.nixos.org/wiki/Web_eID
    firefox = {
      enable = true;
      policies.SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
      nativeMessagingHosts = [pkgs.web-eid-app];
    };
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
      extensions = [
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
      ];
    };
  };
}
