{
  inputs,
  config,
  pkgs,
  ...
}:

{

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "eu";
    };
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  xdg.autostart.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security.pam.services.gdm.enableGnomeKeyring = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  environment.variables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpolkitagent

    waybar
    pavucontrol
    dunst
    playerctl
    networkmanagerapplet
    rofi-wayland

    adwaita-icon-theme
    nautilus
    wl-clipboard
    libsecret
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services = {
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      sushi.enable = true;
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
