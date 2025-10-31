{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "org.mozilla.firefox"
    
    "com.google.Chrome"
    "com.brave.Browser"
  ];
}
