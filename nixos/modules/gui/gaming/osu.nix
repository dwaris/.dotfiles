{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "sh.ppy.osu"
  ];

  hardware.opentabletdriver.enable = true;
}
