{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages;

  boot.supportedFilesystems = [
    "zfs"
  ];
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = false;

  boot.initrd.systemd.enable = true;
  boot.initrd.supportedFilesystems = ["zfs"];

  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p";
    frequent = 0;
    hourly = 24;
    daily = 7;
    weekly = 4;
    monthly = 12;
  };
  services.zfs.autoScrub = {
    enable = true;
    pools = ["zpool"];
  };
}
