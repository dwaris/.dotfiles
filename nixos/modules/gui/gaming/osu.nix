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

#  hardware.opentabletdriver.enable = true;
#  hardware.opentabletdriver.daemon.enable = true;
#  hardware.opentabletdriver.blacklistedKernelModules = [ "wacom" ];
}
