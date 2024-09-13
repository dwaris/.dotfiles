{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mangohud
    wineWowPackages.waylandFull
  ];
}
