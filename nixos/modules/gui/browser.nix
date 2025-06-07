{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "com.brave.Browser"

    "org.mozilla.firefox"
    "org.torproject.torbrowser-launcher"
  ];
}
