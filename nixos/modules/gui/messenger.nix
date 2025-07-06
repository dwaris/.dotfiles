{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    element-desktop
    signal-desktop-bin
    telegram-desktop
  ];
  services.flatpak.packages = [
    "com.discordapp.Discord"
    "org.mozilla.Thunderbird"
  ];
}
