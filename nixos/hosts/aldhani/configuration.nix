# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: let
  username = "dwaris";
in {
  imports = [
    ../../modules/core
    ../../modules/hardware/laptop.nix
    ../../modules/hardware/secure-boot.nix
    ../../modules/hardware/zfs.nix
    ../../modules/hardware/printing.nix
    ../../modules/hardware/vpn/wireguard.nix
    ../../modules/hardware/vpn/tailscale-client.nix

    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/oo7.nix

    ../../modules/apps
    ../../modules/apps/sunshine.nix

    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "iommu=pt"
    "amd_pstate=active"
  ];

  networking.hostName = "aldhani"; # Define your hostname.
  networking.hostId = "2ffb69ed";

  services.fprintd.enable = false;

  hardware.graphics.enable = true;
  hardware.amdgpu.opencl.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  environment.systemPackages = with pkgs; [
    llama-cpp-vulkan
    moonlight-qt
  ];

  programs.nh.flake = "/home/${username}/Projects/dotfiles/nixos";

  users.groups.${username} = {
    gid = 1000;
  };
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    group = username;
    description = username;
    extraGroups = ["wheel" "networkmanager" "uinput" "input"];
    shell = pkgs.zsh;
  };

  fileSystems."/home/${username}/Documents" = {
    device = "zpool/shared/${username}/documents";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Downloads" = {
    device = "zpool/shared/${username}/downloads";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Music" = {
    device = "zpool/shared/${username}/music";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Pictures" = {
    device = "zpool/shared/${username}/pictures";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Projects" = {
    device = "zpool/shared/${username}/projects";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Videos" = {
    device = "zpool/shared/${username}/videos";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home/${username}/Nextcloud" = {
    device = "zpool/shared/nextcloud";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
