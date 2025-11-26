{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "com.google.Chrome"
    "com.brave.Browser"
    "com.microsoft.Edge"
  ];
}
