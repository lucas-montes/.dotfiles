{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.azahar
    pkgs.gimp
    pkgs.obs-studio
    pkgs.audacity
    pkgs.nomacs
    pkgs.xournalpp
    pkgs.nautilus

    pkgs.sqlitestudio

    pkgs.usbutils
    pkgs.openssl
    pkgs.ripgrep
    pkgs.jq
    pkgs.alejandra

    pkgs.unzip
    pkgs.zip

    pkgs.wl-clipboard
    pkgs.grimblast
    pkgs.playerctl
    pkgs.libnotify
    pkgs.pavucontrol
    pkgs.brightnessctl
    pkgs.pulseaudio
    pkgs.networkmanagerapplet
  ];
}
