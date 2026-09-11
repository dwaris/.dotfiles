{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_7_2;

  boot.supportedFilesystems = [
    "zfs"
  ];
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = false;

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.emergencyAccess = false;
  boot.initrd.supportedFilesystems = ["zfs"];

  boot.initrd.clevis = {
    enable = true;
    devices."zpool".secretFile = "/etc/clevis/zpool.jwe";
  };

  systemd.oomd.enable = false;

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
