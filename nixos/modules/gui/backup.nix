{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nextcloud-client

    vorta

    localsend
  ];

  fileSystems."/home/dwaris/Nextcloud" = {
    device = "zpool/nextcloud";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317];
  };
}
