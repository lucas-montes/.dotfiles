{
  lib,
  pkgs,
  inputs,
  mainUser,
  stateVersion,
  ...
}: {
  imports = [
    ../luctop/common.nix
    ./hardware-configuration.nix
  ];

  # Pinned to the newest kernel known to work with this flake's ZFS release.
  # linuxPackages_latest can move past ZFS's supported kernel range and break evaluation.
  boot.kernelPackages = pkgs.linuxPackages_7_2;
  users.users.lucas.initialHashedPassword = "$y$j9T$fMB4.mcmYZ7XMrdvrjrYQ.$qJV4/su8c2yZhz17NpJT8QAW02cK9rIdRaJWB93rahA";

  # init_on_alloc zeroes every allocation as a hardening measure, but OpenZFS
  # documents that it "can lower ARC throughput considerably". This kernel
  # (7.2.6) is built with CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y and NixOS does not
  # override it, so turn it off to favor IO throughput. This trades away the
  # uninitialized-memory / use-after-free mitigation the option provides.
  # https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/Workload%20Tuning.html#init-on-alloc
  boot.kernelParams = ["init_on_alloc=0"];

  # Never let installs on the new ESP reorder the old system's NVRAM boot entry.
  # systemd-boot is installed on the currently mounted ESP, but firmware
  # variables keep the old disk as the default entry until cutover.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  # Manage the user profile (apps, dotfiles, desktop config) inside the NixOS
  # evaluation instead of applying it with a separate manual
  # `home-manager switch --flake .#lucas`. The whole profile therefore ends
  # up in the system closure, and disko-install copies it into /nix during
  # the install: the first boot is fully dressed with no network access and
  # no extra setup steps.
  #
  # The home-manager NixOS module itself is already imported via
  # common.nix -> ../../settings/home-manager.nix, which also sets
  # backupFileExtension so pre-existing files get a .backup suffix instead
  # of an activation failure.
  #
  # The bare `.#lucas` homeConfigurations output keeps working for the other
  # hosts (lucver, raspi4); this host no longer needs it.
  home-manager = {
    # Deliberately NOT setting useGlobalPkgs: home-packages.nix declares
    # `nixpkgs.config.allowUnfree`, which the HM module system forbids when
    # the profile is told to use the host's nixpkgs instance. Evaluating the
    # profile's own nixpkgs also keeps this exact module reusable by the
    # standalone `#lucas` homeConfigurations output, whose flake-only
    # pkgs instance needs the allowUnfree declaration of its own. Both
    # nixpkgs evaluations end up identical for these hosts; the cost is
    # evaluation time only.
    #
    # Put user packages under /etc/profiles/per-user/<name> and let the
    # system activation manage them, instead of a user-owned ~/.nix-profile.
    useUserPackages = true;
    # home.nix and its modules expect the same argument set that the
    # standalone homeManagerConfiguration passes via extraSpecialArgs
    # (flake.nix: inputs, mainUser, stateVersion). All of them must be here:
    # e.g. modules/stylix.nix uses `inputs` inside a module `imports`, and a
    # missing one makes the module system fall back to _module.args, which
    # needs config -> infinite recursion during evaluation.
    extraSpecialArgs = {inherit inputs mainUser stateVersion;};
    users.${mainUser} = import ../../home-manager/home.nix;
  };
}
