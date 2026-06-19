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

  ];
  services.flatpak.packages = [
    "com.mastermindzh.tidal-hifi"
    "tv.plex.PlexDesktop"
    "com.plexamp.Plexamp"
  ];
}
