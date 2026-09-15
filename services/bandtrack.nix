{
  services.bandtrack = {
    enable = true;
    retainDays = 90;
    dataDir = "/var/lib/bandtrack";
    includeLo = false;
    cli.enable = true;
  };
  users.groups.bandtrack.members = ["lucas"];
}
