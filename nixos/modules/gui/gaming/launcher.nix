{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "com.usebottles.bottles"
    "org.ryujinx.Ryujinx"
  ];
}
