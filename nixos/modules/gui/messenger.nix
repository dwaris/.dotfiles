{
  config,
  lib,
  pkgs,
  ...
}: {
  services.flatpak.packages = [
    "com.discordapp.Discord"

    "im.riot.Riot"

    "org.mozilla.Thunderbird"
  ];

  services.protonmail-bridge.enable = false;
  services.protonmail-bridge.path = [ pkgs.gnome-keyring ];
}
