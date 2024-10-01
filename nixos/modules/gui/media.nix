{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    plexamp
    plex-desktop
    mpv
    tauon
    tidal-hifi
  ];
}
