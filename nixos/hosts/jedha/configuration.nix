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

  boot.kernelPackages = pkgs.linuxPackages_6_15;
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

  nixpkgs.config.packageOverrides = pkgs: {
    linux-firmware = pkgs.linux-firmware.overrideAttrs (oldAttrs: rec {
      version = "20250509";
      src = pkgs.fetchzip {
        url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-${version}.tar.xz";
        hash = "sha256-0FrhgJQyCeRCa3s0vu8UOoN0ZgVCahTQsSH0o6G6hhY=";
      };
    });
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
