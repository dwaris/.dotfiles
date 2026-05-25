{
  imports = [
    ./headless.nix
    ../desktop
    ../gui
  ];

  # specialisation = {
  #   gnome = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ../desktop/gnome.nix ];
  #       system.nixos.tags = [ "gnome" ];
  #     };
  #   };
  #
  #   kde = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ../desktop/kde.nix ];
  #       system.nixos.tags = [ "kde" ];
  #     };
  #   };
  #
  #   hyprland = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ../desktop/hyprland.nix ];
  #       system.nixos.tags = [ "hyprland" ];
  #     };
  #   };
  #
  #   cosmic = {
  #     inheritParentConfig = true;
  #     configuration = {
  #       imports = [ ../desktop/cosmic.nix ];
  #       system.nixos.tags = [ "cosmic" ];
  #     };
  #   };
  # };
}
