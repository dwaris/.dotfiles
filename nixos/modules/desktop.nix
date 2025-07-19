{ config, pkgs, ... }: 

{
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
  boot.supportedFilesystems = [
    "zfs"
    "nfs"
    "ntfs"
  ];

  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = true;

  boot.initrd.systemd.enable = true;
  boot.initrd.supportedFilesystems = ["zfs"];

  environment.systemPackages = with pkgs; [
    sbctl
    nfs-utils
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

  # Enable nftables
  networking.firewall.enable = true;
  networking.nftables.enable = true;
  services.tailscale.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = true; 
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "dwaris" ];
    };
  };

  services.printing.enable = false;
  services.avahi = {
    enable = false;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.flatpak.enable = true;
  environment.sessionVariables.XDG_DATA_DIRS = ["/var/lib/flatpak/exports/share"];

  services.fwupd.enable = true;

  programs.adb.enable = true;
  users.users.dwaris.extraGroups = [
    "networkmanager"
    "docker"
    "adbusers"
    "gamemode"
  ];
}