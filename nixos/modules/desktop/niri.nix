{
  pkgs,
  ...
}: {
  imports = [
    ../cli/mpd.nix
  ];

  programs.niri = {
    enable = true;
  };

  programs.xwayland.enable = true;

  services.displayManager.gdm = {
    enable = true;
  };
  services.displayManager.defaultSession = "niri";

  environment.systemPackages = with pkgs; [
    niri
    xwayland-satellite
    noctalia

    wl-clipboard
    cliphist
    libsecret

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
    gnome-calculator
    gnome-text-editor
    gnome-system-monitor
  ];

  # XDG Desktop Portals
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      niri = {
        default = [ "gnome" "gtk" ];
      };
    };
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
