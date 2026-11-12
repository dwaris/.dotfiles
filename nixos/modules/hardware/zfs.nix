{
  config,
  pkgs,
  lib,
  ...
}: let
  zfsModule = config.boot.zfs.package.kernelModuleAttribute;

  # OpenZFS 2.4.4 does not yet officially support Linux 7.3.
  # Ubuntu backported the 7.3 compat commits from OpenZFS master (openzfs/zfs#19032)
  # in zfs-linux 2.4.4-1ubuntu4.
  zfsLinux73Compat = _: prev: {
    ${zfsModule} =
      if prev.${zfsModule}.version == "2.4.4" && lib.versions.majorMinor prev.kernel.version == "7.3"
      then
        prev.${zfsModule}.overrideAttrs (old: {
          patches =
            (old.patches or [])
            ++ [
              ./zfs-linux-7.3/linux-7.3-iops-create-no-flag.patch
              ./zfs-linux-7.3/linux-7.3-bvec-iter-bi-offset.patch
              ./zfs-linux-7.3/linux-cpu-feature-enabled.patch
              ./zfs-linux-7.3/linux-7.3-kthread-init-fs.patch
            ];
          configureFlags = (old.configureFlags or []) ++ ["--enable-linux-experimental"];
          meta = (old.meta or {}) // {broken = false;};
        })
      else prev.${zfsModule};
  };
in {
  boot.kernelPackages = pkgs.linuxPackages_latest.extend zfsLinux73Compat;

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
