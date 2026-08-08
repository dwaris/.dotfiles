{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../cli/mpd.nix
    ./oo7.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  systemd.user.services.hypridle.path = [
    pkgs.brightnessctl
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };
  services.displayManager.defaultSession = "hyprland-uwsm";
  environment.systemPackages = with pkgs; [
    awww
    hyprpolkitagent
    hypridle
    hyprshot

    hyprshutdown

    waybar
    bluetui
    networkmanagerapplet
    wiremix
    brightnessctl

    mako
    libnotify

    rofi

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
    sioyek

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
      localsearch.enable = true;
      glib-networking.enable = true;
    };
  };

  programs.dconf.enable = true;
}
