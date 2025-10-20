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
    appimage-run
  ];

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  services.smartd = {
    autodetect = true;
    enable = true;
  };

  security.pki.certificateFiles = [ ../.certs/root_ca.crt ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ]; 
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable nftables
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "virbr0" ];
  };
  networking.nftables.enable = true;

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

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override { extraPkgs = pkgs: [
    pkgs.icu
    pkgs.libxcrypt-legacy
    ];
  };

  services.fwupd.enable = true;

  programs.adb.enable = true;
  users.users.dwaris.extraGroups = [
    "networkmanager"
    "docker"
    "adbusers"
    "gamemode"
  ];
}