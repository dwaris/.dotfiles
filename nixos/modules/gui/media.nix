{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    mpv
    tauon
    tidal-hifi

    komikku
    foliate
  ];

  services.flatpak.packages = [
    "com.plexamp.Plexamp"
    "tv.plex.PlexDesktop"
  ];
}
