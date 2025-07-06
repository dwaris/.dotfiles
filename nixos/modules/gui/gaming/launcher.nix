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
    atlauncher
  ];
  
}
