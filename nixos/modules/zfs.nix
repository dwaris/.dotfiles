{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages;

  boot.supportedFilesystems = [
    "zfs"
  ];
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = false;

  boot.initrd.systemd.enable = true;
  boot.initrd.supportedFilesystems = ["zfs"];
}
