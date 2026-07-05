{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./steam.nix
    ./launcher.nix
    ./osu.nix
  ];
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  fileSystems."/home/dwaris/Games" = {
    device = "zpool/shared/games";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  services.scx.extraArgs = [
    "-m"
    "performance"
    "-w"
  ];
  services.ananicy = {
    enable = true;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };
}
