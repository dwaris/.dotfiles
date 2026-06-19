{
  config,
  lib,
  pkgs,
  ...
}: {
  services.flatpak.packages = [
    "com.discordapp.Discord"
    "im.riot.Riot"

    "org.mozilla.thunderbird"
  ];
}
