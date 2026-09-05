{pkgs, ...}: {
  imports = [
    ./default.nix
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

  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    awww
    hyprpolkitagent
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

    nwg-look
    adw-gtk3
    adwaita-icon-theme
    kdePackages.qt6ct
    kdePackages.breeze-icons
    rose-pine-hyprcursor

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
}
