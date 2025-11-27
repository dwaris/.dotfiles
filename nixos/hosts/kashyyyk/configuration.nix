# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../../modules

    ../../modules/cli
    ../../modules/cli/podman.nix

    ../../modules/gui
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [ 
    "zfs.zfs_arc_max=8589934592" # 8 GiB 
  ];

  networking.hostName = "kashyyyk"; # Define your hostname.
  networking.hostId = "f0cacf30";

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = true;
  
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  services.thermald.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
