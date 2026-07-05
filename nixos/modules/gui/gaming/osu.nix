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

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
}
