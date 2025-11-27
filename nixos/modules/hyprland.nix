{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = lib.mkForce false; # disables the default hypridle service, start it only in hyprland

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  xdg.autostart.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpolkitagent
    hypridle
    waybar

    grim
    slurp

    networkmanagerapplet
    pavucontrol
    dunst
    rofi
    wlogout
    brightnessctl

    wl-clipboard
    libsecret
    neovide

    nwg-look
    adw-gtk3
    adwaita-icon-theme
    kdePackages.qt6ct
    kdePackages.breeze-icons

    file-roller
    papers
    loupe
    nautilus
    gnome-calculator
    gnome-disk-utility
    gnome-system-monitor
    gnome-usage
    gnome-logs
    gnome-font-viewer
  ];

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    gnome = {
      sushi.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
    power-profiles-daemon.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
