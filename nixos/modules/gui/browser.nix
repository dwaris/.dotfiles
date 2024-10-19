{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "com.brave.Browser"
    "net.mullvad.MullvadBrowser"
    "org.torproject.torbrowser-launcher"
  ];
}
