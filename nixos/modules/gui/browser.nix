{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "org.mozilla.firefox"
    "org.torproject.torbrowser-launcher"
    
    "org.chromium.Chromium"
  ];
}
