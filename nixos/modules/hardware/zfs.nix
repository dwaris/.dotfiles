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

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "zfs-tpm-rekey" ''
      set -euo pipefail
      read -r -s -p "Enter ZFS passphrase: " pass
      echo ""
      if [ -z "$pass" ]; then
        echo "Error: Passphrase cannot be empty." >&2
        exit 1
      fi
      sudo mkdir -p /etc/clevis
      echo -n "$pass" | sudo ${pkgs.clevis}/bin/clevis encrypt tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,7"}' | sudo tee /etc/clevis/zpool.jwe > /dev/null
      sudo chmod 600 /etc/clevis/zpool.jwe
      unset pass
      echo "Successfully updated /etc/clevis/zpool.jwe"
    '')
  ];

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
