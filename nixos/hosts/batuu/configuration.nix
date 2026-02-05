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
    ../../modules/system.nix
    ../../modules/desktop.nix
    ../../modules/kde.nix

    ../../modules/cli
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [networkmanager-openvpn];
  networking.networkmanager.dns = "systemd-resolved";
  systemd.services.NetworkManager-wait-online.enable = false;
  services.resolved.enable = true;

  networking.hostName = "batuu";
  networking.hostId = "97f81ac7";

  environment.systemPackages = with pkgs; [
    ghostty
    tmux

    vlc

    gimp

    libreoffice
  ];

  hardware.bluetooth.enable = true;

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

  services.flatpak.packages = [
    "com.google.Chrome"
    "com.brave.Browser"

    "org.mozilla.firefox"
  ];

  system.stateVersion = "25.05";
}
