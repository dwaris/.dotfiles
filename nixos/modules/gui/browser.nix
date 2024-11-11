{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "org.chromium.Chromium"
    "io.gitlab.librewolf-community"
    "org.torproject.torbrowser-launcher"
  ];
}
