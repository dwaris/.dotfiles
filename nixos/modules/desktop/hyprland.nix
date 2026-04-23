{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.ly.enable = true;

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpolkitagent
    hypridle
    hyprshot

    hyprshutdown

    waybar
    bluetui
    wiremix
    brightnessctl

    mako
    libnotify

    walker
    elephant

    wl-clipboard
    cliphist

    nwg-look
    adw-gtk3
    adwaita-icon-theme
    kdePackages.qt6ct
    kdePackages.breeze-icons

    file-roller
    papers
    loupe
    nautilus
    gnome-disk-utility
    baobab
    gnome-logs
  ];

  xdg.portal = {
    xdgOpenUsePortal = true;
    config.common."org.freedesktop.impl.portal.Secret" = "gnome-keyring";
  };

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
    accounts-daemon.enable = true;
    gnome = {
      sushi.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
