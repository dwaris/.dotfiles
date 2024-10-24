{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.packages = [
    "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08"
    "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
    "com.github.Matoking.protontricks"
  ];
}
