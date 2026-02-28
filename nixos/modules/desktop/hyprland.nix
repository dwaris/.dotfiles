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

  security.pam.services = {
    greetd.kwallet = {
      enable = true;
      forceRun = true;
    };
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpolkitagent
    hypridle
    wlogout
    waybar

    grim
    slurp

    bluetui
    wiremix
    brightnessctl

    dunst
    rofi

    wl-clipboard
    cliphist

    nwg-look
    adw-gtk3
    adwaita-icon-theme
    kdePackages.qt6ct
    kdePackages.breeze-icons

    kdePackages.kwallet
    kdePackages.kwallet-pam

    nomacs
    kdePackages.kservice
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.filelight
    unrar
  ];

  # https://github.com/NixOS/nixpkgs/issues/409986
  environment.etc."xdg/menus/applications.menu".source = ./dolphin.menu;

  xdg.portal = {
    xdgOpenUsePortal = true;
  };

  programs.partition-manager.enable = true;

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    accounts-daemon.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
