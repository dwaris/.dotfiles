# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system.nix
    ../../modules/desktop.nix
    ../../modules/kde.nix

    ../../modules/cli

    ../../modules/gui/browser.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ]; 
  systemd.services.NetworkManager-wait-online.enable = false;
  services.resolved.enable = true;

  networking.hostName = "kashyyyk";
  networking.hostId = "f0cacf30";

  environment.systemPackages = with pkgs; [ 
    vlc
    libreoffice
  ];

  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = true;
  
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  services.printing.enable = true;
  services.thermald.enable = true;

  users.users.betty = {
    isNormalUser = true;
    description = "betty";
    extraGroups = [ "networkmanager" ];
  };

  system.stateVersion = "25.05";
}
