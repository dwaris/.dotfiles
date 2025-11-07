{ config, pkgs, ... }: 

{  
  imports = [
    ./system.nix
    ./fonts.nix
    ./desktop.nix
    ./gnome.nix
    ./hyprland.nix
  ];
}
