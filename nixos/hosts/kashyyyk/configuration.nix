# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules

    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [networkmanager-openvpn];
  systemd.services.NetworkManager-wait-online.enable = false;
  services.resolved.enable = true;

  networking.hostName = "kashyyyk";
  networking.hostId = "f0cacf30";

  environment.systemPackages = with pkgs; [
    ghostty
    tmux

    vlc

    gimp

    firefox
    chromium

    libreoffice-qt
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
  ];

  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime-legacy1
  ];

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

  system.stateVersion = "25.05";
}
