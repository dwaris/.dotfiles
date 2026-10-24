{
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (_: prev: {
      kernelPackagesExtensions =
        prev.kernelPackagesExtensions
        ++ [
          (_: prev: let
            packageName = config.boot.zfs.package.kernelModuleAttribute;
          in {
            ${packageName} = prev.${packageName}.overrideAttrs (old: {
              patches =
                (old.patches or [])
                ++ [
                  (pkgs.writeText "zfs-disable-tmpfile.patch" (builtins.concatStringsSep "\n" [
                    "diff --git a/module/os/linux/zfs/zpl_inode.c b/module/os/linux/zfs/zpl_inode.c"
                    "--- a/module/os/linux/zfs/zpl_inode.c"
                    "+++ b/module/os/linux/zfs/zpl_inode.c"
                    "@@ -279,3 +279,4 @@"
                    "+#if 0"
                    " static int"
                    " #ifdef HAVE_TMPFILE_IDMAP"
                    " zpl_tmpfile(struct mnt_idmap *userns, struct inode *dir,"
                    "@@ -347,5 +348,6 @@"
                    " \treturn (error);"
                    " }"
                    "+#endif"
                    " "
                    " static int"
                    " zpl_unlink(struct inode *dir, struct dentry *dentry)"
                    "@@ -853,3 +853,2 @@"
                    " \t.rename\t\t= zpl_rename,"
                    "-\t.tmpfile\t= zpl_tmpfile,"
                    " \t.setattr\t= zpl_setattr,"
                    ""
                  ]))
                ];
            });
          })
        ];
    })
  ];

  boot.kernelPackages = pkgs.linuxPackages_7_2;

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
      echo -n "$pass" | sudo ${pkgs.clevis}/bin/clevis encrypt tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,7"}' | sudo tee /etc/clevis/zpool.jwe > /dev/null
      sudo chmod 600 /etc/clevis/zpool.jwe
      unset pass
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
