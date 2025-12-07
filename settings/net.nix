{
  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = ["192.168.1.16"];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [8080 8000 3030 3000 3001 3002 3003];
    };
  };
}
