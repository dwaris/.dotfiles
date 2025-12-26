{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  services.scx = lib.mkForce {
    scheduler = "scx_lavd";
    extraArgs = [ "--performance" ];
  };

  programs = { 
    gamemode = {
      enable = true;
      enableRenice = true;
    };
  };

  users.users.dwaris.extraGroups = [
     "gamemode"
  ];

  services.flatpak.packages = [
    "com.valvesoftware.Steam"
    "com.github.Matoking.protontricks"
  ];
}

