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
    device = "zpool/shared/nextcloud";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [53317];
    allowedUDPPorts = [53317];
  };
}
