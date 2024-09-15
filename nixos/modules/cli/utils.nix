{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    zip
    unzip
    unrar
    p7zip

    ripgrep
    htop
    btop

    bottom
    fd
    fastfetch

    rsync

    parallel
  ];
}
