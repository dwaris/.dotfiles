{ lib, ... }:
{
  imports = [
    ./headless.nix
    ../desktop
    ../gui
  ];

  services.tailscale = lib.mkForce {
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--advertise-exit-node"
      "--advertise-routes=192.168.178.0/24"
      "--ssh"
    ];
  };

  # specialisation = {
  #   gnome = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ../desktop/gnome.nix ];
  #       boot.lanzaboote.sortKey = "03";
  #       system.nixos.tags = [ "gnome" ];
  #     };
  #   };
  #   kde = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ../desktop/kde.nix ];
  #       boot.lanzaboote.sortKey = "02";
  #       system.nixos.tags = [ "kde" ];
  #       services.gnome.gnome-keyring.enable = true;
  #     };
  #   };
  #   hyprland = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ../desktop/hyprland.nix ];
  #       boot.lanzaboote.sortKey = "01";
  #       system.nixos.tags = [ "hyprland" ];
  #     };
  #   };
  #   cosmic = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ../desktop/cosmic.nix ];
  #       boot.lanzaboote.sortKey = "04";
  #       system.nixos.tags = [ "cosmic" ];
  #     };
  #   };
  # };
}
