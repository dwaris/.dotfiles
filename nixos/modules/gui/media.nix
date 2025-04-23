{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    mpv
    vlc
    tidal-hifi

    komikku
    foliate
  ];

  services.flatpak.packages = [
    "com.plexamp.Plexamp"
    "tv.plex.PlexDesktop"
  ];
}
