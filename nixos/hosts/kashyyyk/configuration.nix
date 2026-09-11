# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    ../../modules/core
    ../../modules/hardware/laptop.nix
    ../../modules/hardware/secure-boot.nix
    ../../modules/hardware/printing.nix
    ../../modules/desktop/kde.nix

    ./hardware-configuration.nix
  ];
  networking.hostName = "kashyyyk";
  networking.hostId = "e409d00a";

  environment.systemPackages = with pkgs; [
    vlc

    gimp

    firefox
    chromium

    thunderbird
    element-desktop

    libreoffice-qt
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
  ];

  boot.kernelParams = [
    "quiet"
  ];
  boot.plymouth.enable = true;

  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime-legacy1
  ];

  zramSwap.enable = true;
  services.thermald.enable = true;

  users.users.betty = {
    isNormalUser = true;
    description = "betty";
    extraGroups = ["wheel" "networkmanager"];
  };
  users.users.andrew33 = {
    isNormalUser = true;
    description = "andrew33";
    extraGroups = ["wheel" "networkmanager"];
  };
  users.users.nils06 = {
    isNormalUser = true;
    description = "nils06";
    extraGroups = ["wheel" "networkmanager"];
  };

  system.stateVersion = "26.05";
}
