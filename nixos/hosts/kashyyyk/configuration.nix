# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../../modules

    ../../modules/cli

    ../../modules/gui
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [ ];

  networking.hostName = "kashyyyk"; # Define your hostname.
  networking.hostId = "f0cacf30";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  services.printing.enable = false;
  virtualisation.docker.enable = false;

  hardware.bluetooth.enable = true;

  hardware.sensor.iio.enable = true;
  
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vaapiVdpau
    libvdpau-va-gl
  ];

  services.power-profiles-daemon.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
