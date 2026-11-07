{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--password-store=gnome-libsecret"
      ];
      extensions = [{id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}];
    };
  };

  # Maia's capture extension isn't in the Web Store, so it can't go through
  # `programs.chromium.extensions` above. "Load unpacked" this path in Brave
  # once, ever -- every later chrome_ext/ change just needs a rebuild plus a
  # "Reload" click on the extension card in brave://extensions, never
  # re-picking the directory, since this keeps pointing at the current
  # build instead of a path that changes on every rebuild.
  home.file.".local/share/maia/chrome-ext" = {
    source = inputs.maia.packages.${pkgs.stdenv.hostPlatform.system}.chrome-ext;
    recursive = true;
  };
}
