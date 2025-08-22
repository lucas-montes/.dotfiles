{
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.curl
    pkgs.wget
    pkgs.git
    pkgs.cudatoolkit
  ];
}
