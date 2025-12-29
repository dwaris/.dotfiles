{
  config,
  lib,
  pkgs,
  ...
}: {
  services.flatpak.packages = [
    "com.google.Chrome"

    "org.mozilla.firefox"
  ];
}
