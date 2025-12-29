{
  config,
  lib,
  pkgs,
  ...
}: {
  services.flatpak.packages = [
    "com.heroicgameslauncher.hgl"

    "sh.ppy.osu"
    "org.prismlauncher.PrismLauncher"
  ];
}
