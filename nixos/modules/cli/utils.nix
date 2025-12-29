{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # archives
    zip
    unzip

    # network
    rsync

    # system monitoring
    htop
    bottom
    lm_sensors

    # tools
    bat

    # git
    lazygit
  ];
}
