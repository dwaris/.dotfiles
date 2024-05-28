# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }: {
  imports =
    [ # Include the results of the hardware scan.
        ../../modules/system.nix
        ../../modules/kde.nix
        ../../modules/nixos/fonts.nix

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
  };
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" "ntfs" ];

  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = true;

  boot.initrd.systemd.enable = true;
  boot.initrd.supportedFilesystems = [ "zfs" ];

  boot.initrd.kernelModules = [ "zfs" ];
  boot.kernelParams = [
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
  networking.firewall.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.flatpak.enable = true;
  services.printing.enable = false;
  services.fwupd.enable = true;

  virtualisation.docker.enable = true;

  programs.adb.enable = true;
  users.users.dwaris.extraGroups = [ "networkmanager" "docker" "adbusers" ];

  security.pki.certificates = [ "/etc/ssl/certs/root_ca.crt" ];

  hardware.bluetooth.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    vaapiVdpau
    libvdpau-va-gl
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
