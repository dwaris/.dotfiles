{username, ...}: {
  imports = [
    ./default.nix
    ./apps/launchers.nix
    ./apps/minecraft.nix
  ];

  fileSystems."/home/${username}/Games" = {
    device = "zpool/shared/games";
    fsType = "zfs";
    options = ["zfsutil" "nofail"];
  };

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [
      "--performance"
    ];
  };
}
