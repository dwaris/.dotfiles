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

    # komikku
    # foliate

    plex-desktop
    plexamp
  ];
}
