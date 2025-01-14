{
  inputs,
  config,
  pkgs,
  ...
}:

{

  programs.hyprland.enable = true;
  services.xserver = {
    enable = true;
    xkb = {
      layout = "eu";
    };
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    rofi-wayland
    waybar
    kitty
    gnome-icon-theme
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
