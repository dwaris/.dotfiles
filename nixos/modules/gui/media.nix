{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mpv
    vlc

    foliate

    tidal-hifi

    plexamp
    plex-desktop
  ];
}
