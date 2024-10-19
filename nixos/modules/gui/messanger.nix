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
    telegram-desktop

    thunderbird
  ];
  services.flatpak.packages = [
    "com.discordapp.Discord"
  ];
}
