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

  services.noctalia-shell.enable = true;

  # programs.hyprlock.enable = true;
  # services.hypridle = {
  #   enable = lib.mkForce false;
  # };

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  security.pam.services.login.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    # hyprpaper
    # hyprsunset
    hyprpolkitagent
    # hypridle
    # wlogout
    # waybar

    # grim
    # slurp

    # bluetui
    # wiremix
    brightnessctl

    # dunst
    # rofi

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
    gnome-calculator
    gnome-disk-utility
    gnome-system-monitor
    gnome-logs
    gnome-font-viewer
  ];

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
