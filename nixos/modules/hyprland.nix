{
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;

  services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

  xdg.autostart.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security.pam.services.login.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprsunset
    hyprpolkitagent
    waybar

    grim
    slurp

    pavucontrol
    dunst
    playerctl
    networkmanagerapplet
    rofi-wayland
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

    rustdesk-flutter

    file-roller
    papers
    loupe
    nautilus
    gnome-calculator
    gnome-disk-utility
    gnome-system-monitor
    gnome-usage
    gnome-font-viewer
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services = {
    blueman.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      sushi.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
