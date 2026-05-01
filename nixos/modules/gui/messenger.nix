{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    discord
    element-desktop

    thunderbird
  ];
}
