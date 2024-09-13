{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    osu-lazer-bin
  ];

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  hardware.opentabletdriver.blacklistedKernelModules = [ "wacom" ];
}
