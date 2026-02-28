{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./system.nix

    ./desktop

    ./cli
    ./gui
 ];

 specialisation = {
    # gnome = {
    #   inheritParentConfig = true;
    #   configuration = {
    #     imports = [ ./desktop/gnome.nix ];
    #     boot.lanzaboote.sortKey = "01";
    #     system.nixos.tags = [ "gnome" ];
    #   };
    # };
    kde = {
      inheritParentConfig = true;
      configuration = {
        imports = [ ./desktop/kde.nix ];
        boot.lanzaboote.sortKey = "02";
        system.nixos.tags = ["kde"];
      };
    };
    hyprland = {
      inheritParentConfig = true;
      configuration = {
        imports = [ ./desktop/hyprland.nix ];
        boot.lanzaboote.sortKey = "01";
        system.nixos.tags = ["hyprland"];
      };
    };
  };
}
