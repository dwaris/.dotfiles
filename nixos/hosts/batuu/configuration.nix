# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: let
  username = "dwaris";
in {
  imports = [
    ../../modules/core
    ../../modules/hardware/laptop.nix
    ../../modules/hardware/boot.nix
    ../../modules/hardware/printing.nix
    ../../modules/desktop/gnome.nix

    ../../modules/apps

    ./hardware-configuration.nix
  ];

  networking.hostName = "batuu";
  networking.hostId = "264853fa";

  hardware.bluetooth.enable = true;
  harware.bluetooth.powerOnBoot = false;

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime-legacy1
  ];

  zramSwap.enable = true;
  services.thermald.enable = true;

  programs.nh.flake = "/home/${username}/Projects/dotfiles/nixos";

  users.groups.${username} = {
    gid = 1000;
  };
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    group = username;
    description = username;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";
}
