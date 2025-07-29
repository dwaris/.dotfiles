{ config, pkgs, ... }: 

{  
  imports = [
    ./system.nix
    ./fonts.nix
    ./desktop.nix
    ./hyprland.nix
    ./gnome.nix
  ];
}
