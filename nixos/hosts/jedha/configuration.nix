# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
        ../../modules/system.nix
        ../../modules/kde.nix
        ../../modules/nixos/fonts.nix

        ../../modules/nixos/steam.nix
        ../../modules/nixos/opentabletdriver.nix

        ../../modules/nixos/virtualization.nix
#        ../../modules/nixos/makemkv.nix
 
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot = {
      enable = false;
      configurationLimit = 10;
    };
    boot.lanzaboote = {
     enable = true;
     pkiBundle = "/etc/secureboot";
     #settings = {
     #   default = "@saved";
     # };
  };
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" "ntfs" ];

  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = true;

  boot.initrd.systemd.enable = true;
  boot.initrd.supportedFilesystems = [ "zfs" ];

  boot.initrd.kernelModules = [ "zfs" "amdgpu" ];
  boot.kernelParams = [
    "video=DP-1:2560x1440@165"
    "video=HDMI-A-1:1920x1080@75"
  ];

  networking.hostName = "jedha"; # Define your hostname.
  networking.hostId = "74f65184";

  environment.systemPackages = with pkgs; [
    nfs-utils
    sshfs
    sbctl
  ];

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  security.pki.certificates = [ "/etc/ssl/certs/root_ca.crt" ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.flatpak.enable = false;
  services.printing.enable = false;
  services.fwupd.enable = true;

  virtualisation.docker.enable = true;

  programs.adb.enable = true;
  users.users.dwaris.extraGroups = [ "networkmanager" "docker" "adbusers" ];

  hardware.bluetooth.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  #hardware.graphics.extraPackages = with pkgs; [
  #  rocmPackages.clr.icd
  #];
  programs.hyprland.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
