{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mkvtoolnix
    obs-studio
  ];
}
