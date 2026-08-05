{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../cli/mpd.nix
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
  security.pam.services.sddm.enableGnomeKeyring = true;

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
      localsearch.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
  };

  programs.dconf.enable = true;

  nixpkgs.overlays = [
    # REVIEW: drop once
    # https://github.com/NixOS/nixpkgs/pull/549253
    # lands on nixos-unstable
    (final: prev: {
      hyprland = prev.hyprland.overrideAttrs (oldAttrs: {
        postPatch =
          ''
            # Relax glaze dependency
            # FIXME: this shouldn't be needed once the upstream code will adopt it
            substituteInPlace CMakeLists.txt start/CMakeLists.txt hyprpm/CMakeLists.txt \
              --replace-fail "glaze 7...<8" "glaze"

          ''
          + (oldAttrs.postPatch or "");
      });
    })
  ];
}
