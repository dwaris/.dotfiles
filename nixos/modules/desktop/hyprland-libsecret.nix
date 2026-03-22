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
    xwayland.enable = false;
  };

  programs.hyprlock.enable = true;
  services.hypridle = {
    enable = lib.mkForce false;
  };

  services.gdm = {
    enable = true;
    wayland = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpolkitagent
    hypridle
    wlogout
    waybar

    grim
    slurp

    bluetui
    wiremix
    brightnessctl

    dunst
    rofi

    wl-clipboard
    cliphist
    libsecret

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
  ];

  xdg.portal = {
    xdgOpenUsePortal = true;
  };

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      sushi.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
