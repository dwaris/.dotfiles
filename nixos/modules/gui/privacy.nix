{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    veracrypt
    protonvpn-gui
  ];
}
