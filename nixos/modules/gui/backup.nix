{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nextcloud-client

    vorta
  ];

  fileSystems."/home/dwaris/Nextcloud" = {
    device = "zpool/nextcloud";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };
}
