{ config, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/programs
    ../../modules/home-manager/shell

    ../../modules/home-manager/programs/game-launchers.nix
    ../../modules/home-manager/programs/gnu-radio.nix
    ../../modules/home-manager/programs/makemkv.nix
    ../../modules/home-manager/programs/prusa.nix
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

        vscode-fhs
        texlive.combined.scheme-medium

        mkvtoolnix

        stow
        alacritty
        neovide

        love

        vorta
        veracrypt
        protonvpn-gui
];

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "floorp";
    TERMINAL = "alacritty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11"; # Please read the comment before changing.
}
