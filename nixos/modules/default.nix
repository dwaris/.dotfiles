{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./system.nix

    ./desktop
    ./desktop/kde.nix

    ./cli
    ./gui

 ];

  # specialisation = {
  #   gnome = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ./desktop/gnome.nix ];
  #       boot.lanzaboote.sortKey = "01";
  #       system.nixos.tags = [ "gnome" ];
  #     };
  #   };
  #   kde = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ./desktop/kde.nix ];
  #       boot.lanzaboote.sortKey = "01";
  #       system.nixos.tags = ["kde"];

  #       # keep kwallet in kde module but disable it here to avoid conflicts between different desktop environments; gnome-keyring is preferred
  #       services.gnome.gnome-keyring.enable = true;
  #     };
  #   };
  #   hyprland = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ./desktop/hyprland.nix ];
  #       boot.lanzaboote.sortKey = "02";
  #       system.nixos.tags = ["hyprland"];
  #     };
  #   };
  # };
}
