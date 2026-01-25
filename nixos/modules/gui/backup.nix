{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nextcloud-client
    # opencloud-desktop

    vorta
  ];

  fileSystems."/home/dwaris/Nextcloud" = {
    device = "zpool/nextcloud";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  # fileSystems."/home/dwaris/OpenCloud" = {
  #   device = "zpool/opencloud";
  #   fsType = "zfs";
  #   options = ["zfsutil" "nofail"];
  # };
}
