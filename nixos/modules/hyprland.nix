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

  services.greetd = {
    enable = true;
    settings = {
        initial_session = rec {
          command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
          user = "dwaris";
        };
        default_session = initial_session;
        };
      };
    };
  };

  boot = {
    plymouth.enable = true;
    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    loader.timeout = 0;
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
    hyprpolkitagent
    waybar

    grim
    slurp

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
    gnome-font-viewer
  ];

  services = {
    blueman.enable = true;
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
