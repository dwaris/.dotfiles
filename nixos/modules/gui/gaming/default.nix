{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./steam.nix
    ./launcher.nix
  ];

  fileSystems."/home/dwaris/Games" = {
    device = "zpool/games";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  # scx_bpfland is crashing with power profile "performance", don't use scx for now
  # services.scx = lib.mkForce {
  #   scheduler = "scx_lavd";
  #   extraArgs = ["--performance"];
  # };
}
