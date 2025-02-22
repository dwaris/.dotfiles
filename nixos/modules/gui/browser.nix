{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "org.chromium.Chromium"

    "org.mozilla.firefox"
    "org.torproject.torbrowser-launcher"
  ];
}
