# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
        ../../modules/system.nix
        ../../modules/gnome.nix
        ../../modules/sway.nix
        ../../modules/hypr.nix
        ../../modules/nixos/fonts.nix

        ../../modules/nixos/steam.nix
        ../../modules/nixos/opentabletdriver.nix
        ../../modules/nixos/virtualization.nix
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

#  boot.loader.grub = {
#    enable = true;
#    default = "saved";
#    zfsSupport = true;
#    efiSupport = true;
#    efiInstallAsRemovable = true;
#    useOSProber = true;
#    mirroredBoots = [
#      { devices = [ "nodev"]; path = "/boot"; }
#    ];
#  };

  boot.loader.systemd-boot.enable = false;
  boot.lanzaboote = {
     enable = true;
     pkiBundle = "/etc/secureboot";
  };
  boot.loader.systemd-boot.configurationLimit = 10;
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
    sbctl
  ];

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  security.pki.certificates = [ "/etc/ssl/certs/root_ca.crt" ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;
  services.flatpak.enable = true;
  services.printing.enable = false;

  virtualisation.docker.enable = true;

  programs.adb.enable = true;
  users.users.dwaris.extraGroups = [ "networkmanager" "docker" "adbusers" ];

  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
  hardware.opengl.driSupport = true; # This is already enabled by default
  hardware.opengl.driSupport32Bit = true; # For 32 bit applications

  services.xserver.videoDrivers = [ "amdgpu" ];

#  environment.sessionVariables.NIXOS_OZONE_WL = "1"; Wayland is not ready for prime time yet

  system.stateVersion = "23.11"; # Did you read the comment?
}
