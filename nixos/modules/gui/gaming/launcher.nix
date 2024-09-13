{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    lutris
    ryujinx
    prismlauncher
  ];
}
