{
  services.bandtrack = {
    enable = true;
    retainDays = 90;
    dataDir = "/var/lib/bandtrack";
    includeLo = false;
  };
  users.groups.bandtrack.members = ["lucas"];
}
