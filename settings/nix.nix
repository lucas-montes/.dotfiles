{pkgs, ...}: {
  nix = {
    settings = {
      trusted-users = ["@wheel"];
      auto-optimise-store = false;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
        "https://hyprland.cachix.org"
        "https://cache.numtide.com"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      keep-outputs = false;
      keep-derivations = false;

      # A stalled substituter (e.g. cache.numtide.com under load) otherwise
      # hangs each download attempt for its full 300s default before even
      # trying the next of the 5 default attempts -- up to 25 minutes wasted
      # on one nar. Fail fast and let nix move on (retry, fall back to
      # another substituter, or build locally) instead.
      connect-timeout = 5;
      stalled-download-timeout = 20;
      download-attempts = 3;
    };
    optimise.automatic = true;
    package = pkgs.nixVersions.stable;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
