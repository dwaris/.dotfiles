{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mpv
    vlc
    tidal-hifi

    foliate

    plex-desktop
    plexamp
  ];
}
