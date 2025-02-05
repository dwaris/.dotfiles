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
    "net.mullvad.MullvadBrowser"
    "org.torproject.torbrowser-launcher"
  ];
}
