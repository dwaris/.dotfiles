# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules

    ../../modules/cli

    ../../modules/gui
    ../../modules/gui/gaming
    ../../modules/gui/virtualization.nix
    ../../modules/gui/android.nix

    ../../modules/gui/gaming/osu.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_14;
  boot.initrd.kernelModules = [
    "zfs"
    "amdgpu"
  ];
  boot.kernelParams = [
    "video=DP-1:2560x1440@144"
    "video=DP-2:1920x1080@60"
  ];

  networking.hostName = "jedha"; # Define your hostname.
  networking.hostId = "74f65184";

  environment.systemPackages = with pkgs; [
    veracrypt

    qbittorrent
    easyeffects
  ];

  services.printing.enable = false;
  virtualisation.docker.enable = true;

  hardware.bluetooth.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.pipewire.extraConfig.pipewire."10-clock-rate" = {
    "context.properties" = {
      "default.clock.allowed-rates" = [
        44100
        48000
        88200
        96000
      ];
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
