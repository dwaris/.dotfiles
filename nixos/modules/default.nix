{ config, pkgs, ... }:

{
  imports = [
    ./system.nix
    ./boot.nix
  ];

  specialisation = {
    gnome = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./desktop.nix
          ./gnome.nix
        ];
        boot.lanzaboote.sortKey = "02";
        system.nixos.tags = [ "gnome" ];
      };
    };
    kde = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./desktop.nix
          ./kde.nix
        ];
        boot.lanzaboote.sortKey = "03";
        system.nixos.tags = [ "kde" ];
      };
    };
    hyprland = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./desktop.nix
          ./hyprland.nix
        ];
        boot.lanzaboote.sortKey = "01";
        system.nixos.tags = [ "hyprland" ];
      };
    };
  };
}
