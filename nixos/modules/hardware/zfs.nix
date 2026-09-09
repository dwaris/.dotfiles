{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_7_2;

  boot.supportedFilesystems = [
    "zfs"
  ];
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = false;

  boot.initrd.systemd.enable = true;
  boot.initrd.supportedFilesystems = ["zfs"];

  boot.initrd.clevis = {
    enable = true;
    devices."zpool".secretFile = "/etc/clevis/zpool.jwe";
  };

  systemd.services.tpm-pcr15-invalidation = {
    description = "Invalidate PCR 15 to lock disk keys away from runtime userspace";
    wantedBy = ["multi-user.target"];
    unitConfig.ConditionPathExists = "/dev/tpmrm0";
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
