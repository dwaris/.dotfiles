{ config, lib, pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.waybar = {
    enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    dunst
    libnotify
    swww
    rofi-wayland
  ];
}
