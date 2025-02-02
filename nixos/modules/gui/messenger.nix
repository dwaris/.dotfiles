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
    "com.discordapp.Discord"
    "org.telegram.desktop"
    "org.mozilla.Thunderbird"
  ];
}
