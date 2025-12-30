{
  config,
  pkgs,
  lib,
  ...
}: let
  zfsCompatibleKernelPackages =
    lib.filterAttrs (
      name: kernelPackages:
        (builtins.match "linux_[0-9]+_[0-9]+" name)
        != null
        && (builtins.tryEval kernelPackages).success
        && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
    )
    pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in {
  # Note this might jump back and forth as kernels are added or removed.
  boot.kernelPackages = latestKernelPackage;
  boot.zfs.package = pkgs.zfs_2_4;


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

  # Enable networking
  networking = {
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      plugins = with pkgs; [networkmanager-openvpn];
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  services.resolved.enable = true;

  # Enable nftables
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["virbr0"];
  };
  networking.nftables.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = false;
    allowSFTP = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["dwaris"];
    };
  };

  users.users.dwaris.extraGroups = [
    "networkmanager"
  ];
}
