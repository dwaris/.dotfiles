{pkgs, ...}: {
  boot.supportedFilesystems = [
    "zfs"
  ];
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = false;

  boot.initrd.systemd.emergencyAccess = false;
  boot.initrd.supportedFilesystems = ["zfs"];

  boot.initrd.clevis = {
    enable = true;
    devices."zpool".secretFile = "/etc/clevis/zpool.jwe";
  };

  boot.initrd.systemd.storePaths = [
    "${pkgs.tpm2-tools}/bin/tpm2_startauthsession"
    "${pkgs.tpm2-tools}/bin/tpm2_policypcr"
  ];

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
      tmp=$(sudo mktemp /etc/clevis/.zpool.jwe.XXXXXX)
      trap 'sudo rm -f -- "$tmp"' EXIT
      printf '%s' "$pass" | sudo ${pkgs.clevis}/bin/clevis encrypt tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,7"}' | sudo tee "$tmp" > /dev/null
      unset pass
      sudo mv -f -- "$tmp" /etc/clevis/zpool.jwe
      trap - EXIT
      echo "Successfully updated /etc/clevis/zpool.jwe"
    '')
  ];

  zramSwap.enable = true;
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
