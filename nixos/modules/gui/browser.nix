{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "org.chromium.Chromium"
    "com.brave.Browser"

    "org.mozilla.firefox"
    "org.torproject.torbrowser-launcher"
  ];
}
