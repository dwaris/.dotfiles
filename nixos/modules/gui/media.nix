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
    vlc
    tauon
    tidal-hifi
  ];
}
