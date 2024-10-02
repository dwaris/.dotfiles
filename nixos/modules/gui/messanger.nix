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

    discord

    thunderbird
  ];
}
