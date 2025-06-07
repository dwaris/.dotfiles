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
    ../../modules/gui/virtualization.nix
    ../../modules/gui/android.nix

    ../../modules/gui/gaming/osu.nix

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
  boot.kernelPackages = pkgs.linuxPackages_6_14;
  boot.supportedFilesystems = [
    "zfs"
    "ntfs"
  ];

  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = true;

  boot.initrd.systemd.enable = true;
  boot.initrd.supportedFilesystems = ["zfs"];

  boot.initrd.kernelModules = [
    "zfs"
    "amdgpu"
  ];
  boot.kernelParams = [
    "video=DP-1:2560x1440@144"
    "video=DP-2:1920x1080@60"
  ];

  networking.hostName = "jedha"; # Define your hostname.
  networking.hostId = "74f65184";

  environment.systemPackages = with pkgs; [
    sshfs
    sbctl

    veracrypt

    qbittorrent
    easyeffects
  ];

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  services.smartd = {
    autodetect = true;
    enable = true;
  };

  security.pki.certificates = ["/etc/ssl/certs/root_ca.crt"];

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.flatpak.enable = true;

  environment.sessionVariables.XDG_DATA_DIRS = ["/var/lib/flatpak/exports/share"];

  services.printing.enable = false;
  services.fwupd.enable = true;

  virtualisation.docker.enable = true;

  programs.adb.enable = true;
  users.users.dwaris.extraGroups = [
    "networkmanager"
    "docker"
    "adbusers"
  ];

  hardware.bluetooth.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.pipewire.extraConfig.pipewire."10-clock-rate" = {
    "context.properties" = {
      "default.clock.allowed-rates" = [
        44100
        48000
        88200
        96000
      ];
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
