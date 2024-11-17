{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    element-desktop
    signal-desktop
  ];
  services.flatpak.packages = [
    "dev.vencord.Vesktop"
    "org.telegram.desktop"
    "org.mozilla.Thunderbird"
  ];
}
