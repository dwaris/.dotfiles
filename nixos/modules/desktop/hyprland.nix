{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../networking/iwd-networkd.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.autoLogin = {
    enable = true;
    user = "dwaris";
  };
  services.displayManager.defaultSession = "hyprland-uwsm";
  security.pam.services.sddm.enableGnomeKeyring = true;

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
    rose-pine-hyprcursor

    powertop

    file-roller
    nautilus
    loupe
    totem
    papers
    gnome-epub-thumbnailer
    gnome-disk-utility
    baobab
    gnome-logs
    seahorse
  ];

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      gnome-keyring
    ];
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
