{ pkgs, config, ... }:
let
  pgUser = {
    name = "lucas";
    psswd = "tete2323";
  };
in {
  services.pgadmin = {
    enable = true;
    initialEmail = "admin@admin.com";
    initialPasswordFile = pkgs.writeText "pgadminPW" "${pgUser.psswd}";
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    enableTCPIP = true;
    authentication = ''
      #type database DBuser origin-address auth-method
      local all       all     trust
      # ipv4
      host  all      ${pgUser.name}     0.0.0.0/0      md5
      # ipv6
      host all       ${pgUser.name}     ::/0           md5
    '';
    ensureUsers = [{
      name = pgUser.name;
      ensureClauses.superuser = true;
    }];
    initialScript = pkgs.writeText "backend-init-script" ''
      CREATE ROLE ${pgUser.name} WITH SUPERUSER LOGIN PASSWORD '${pgUser.psswd}' CREATEDB;
    '';
  };

  networking.firewall.allowedTCPPorts =
    [ config.services.postgresql.settings.port config.services.pgadmin.port ];
}
