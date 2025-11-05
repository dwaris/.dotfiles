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

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "zfs.zfs_arc_max=34359738368" # 32 GiB
    "video=DP-1:2560x1440@144"
    "video=DP-2:1920x1080@60"
  ];

  networking.hostName = "jedha"; # Define your hostname.
  networking.hostId = "74f65184";

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "server";
  };

  environment.systemPackages = with pkgs; [
    qbittorrent
    veracrypt
  ];

  hardware.bluetooth.enable = false;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
