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

  boot.loader.systemd-boot = {
    enable = false;
    configurationLimit = 10;
  };
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;
  boot.supportedFilesystems = [
    "zfs"
    "ntfs"
  ];

  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = true;

  boot.initrd.systemd.enable = true;
  boot.initrd.supportedFilesystems = [ "zfs" ];

  boot.initrd.kernelModules = [ "zfs" ];
  boot.kernelParams =
    [
    ];

  networking.hostName = "kashyyyk"; # Define your hostname.
  networking.hostId = "f0cacf30";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;
  services.flatpak.enable = true;
  services.flatpak.update.onActivation = true;

  environment.sessionVariables.XDG_DATA_DIRS = [ "/var/lib/flatpak/exports/share" ];

  services.printing.enable = false;
  services.fwupd.enable = true;

  virtualisation.docker.enable = false;

  programs.adb.enable = true;
  users.users.dwaris.extraGroups = [
    "networkmanager"
    "docker"
    "adbusers"
  ];

  security.pki.certificates = [ "/etc/ssl/certs/root_ca.crt" ];

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
