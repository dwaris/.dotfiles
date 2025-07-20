{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    protonvpn-gui
  ];
}
