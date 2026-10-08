{
  services.maia = {
    enable = true;

    # The API's bearer token, rendered into /etc/maia/config.json. Put the same
    # value in the phone's settings.
    #
    # This is in the flake, so it is in this repository's history, and the
    # generated file is a symlink into /nix/store, which any local user can
    # read. That was accepted rather than keeping the key out of the store with
    # sops. To change it: generate a new value, update the phone, and rewrite
    # history if the old one matters.
    apiKey = "dbff778c861c0fbe5b534eefc988f07c95b3553e660d83d7";

    # Install the desktop app, so it can be launched on demand while the API
    # keeps running as a service. It is a client of the service and reads the
    # same database, so there is nothing extra to start.
    desktop.enable = true;

    # Exercise images are served from here rather than from the database's
    # directory, which keeps 3 GB of media in the working tree instead of
    # /var/lib.
    sourceDir = "/home/lucas/Projects/maia/server";
  };

  # The maia input is pinned in flake.lock, so after committing changes in
  # ~/Projects/maia/server run
  #
  #   nix flake update maia
  #
  # before `nixos-rebuild switch`, or the service keeps running the previously
  # locked commit and the rebuild looks like it did nothing.
}