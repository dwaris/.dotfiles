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

  programs.hyprlock.enable = true;
  services.hypridle = {
    enable = lib.mkForce false;
  };

  services.displayManager.gdm.enable = true;

  programs.uwsm.waylandCompositors = {
    hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/start-hyprland";
    };
  };

  security.pam.services.login.enableGnomeKeyring = true;

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
