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

  boot.initrd.systemd.services.tpm-pcr15-invalidation = {
    description = "Invalidate PCR 15 immediately after ZFS key load";
    requiredBy = ["sysroot.mount"];
    wants = ["dev-tpmrm0.device"];
    after = [
      "zfs-import-zpool.service"
      "dev-tpmrm0.device"
    ];
    before = [
      "sysroot.mount"
      "initrd-cleanup.service"
    ];
    unitConfig.AssertPathExists = "/dev/tpmrm0";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tpm2-tools}/bin/tpm2_pcrextend -T device:/dev/tpmrm0 15:sha256=0000000000000000000000000000000000000000000000000000000000000000";
    };
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
