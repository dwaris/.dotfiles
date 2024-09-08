{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/programs
    ../../modules/home-manager/shell
    ../../modules/home-manager/programs/gui/game-launchers.nix

    ../../modules/home-manager/programs/gui/prusa.nix
    ../../modules/home-manager/programs/gui/vr.nix
    #        ../../modules/home-manager/programs/gui/makemkv.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dwaris";
  home.homeDirectory = "/home/dwaris";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    qbittorrent

    easyeffects

    veracrypt
    protonvpn-gui

    osu-lazer-bin
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    PAGER = "less -R";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11"; # Please read the comment before changing.
}
