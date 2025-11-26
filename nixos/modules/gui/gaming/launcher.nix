{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamemode
      ];
    })    
    prismlauncher
    # mesen
  ];

  services.flatpak.packages = [
    "sh.ppy.osu"
  ];
}
