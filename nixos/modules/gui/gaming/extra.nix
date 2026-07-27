{
  ...
}: {
  imports = [
    ./default.nix
    ./apps/launchers.nix
    ./apps/minecraft.nix
    ./apps/osu.nix
  ];

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
}
