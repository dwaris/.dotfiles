{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.flatpak.packages = [
    "com.discordapp.Discord"

    "im.riot.Riot"
    "org.signal.Signal"
    "org.telegram.desktop"

    "org.mozilla.Thunderbird"
  ];
}
