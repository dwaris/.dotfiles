{...}: let
  username = "dwaris";
in {
  fileSystems = {
    "/home/${username}/Documents" = {
      device = "zpool/shared/${username}/documents";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/home/${username}/Downloads" = {
      device = "zpool/shared/${username}/downloads";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/home/${username}/Music" = {
      device = "zpool/shared/${username}/music";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/home/${username}/Pictures" = {
      device = "zpool/shared/${username}/pictures";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/home/${username}/Projects" = {
      device = "zpool/shared/${username}/projects";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/home/${username}/Videos" = {
      device = "zpool/shared/${username}/videos";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/home/${username}/Nextcloud" = {
      device = "zpool/shared/nextcloud";
      fsType = "zfs";
      options = ["zfsutil" "nofail"];
    };
  };
}
