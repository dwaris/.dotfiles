{ config, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/gnu-radio.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dwaris";
  home.homeDirectory = "/home/dwaris";

  nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    neovim
    tmux
    starship
    btop
    bottom
    git
    fzf
    fd
    ripgrep
    gnumake
    cmake
    gcc
    htop
    rsync
    wget
    curl
    stow
    unzip
    vlc
    bash-completion
    neofetch
    rustup
    nodejs
    love
    go
    neovide
    
    firefox-wayland
    vivaldi
    vivaldi-ffmpeg-codecs
    
    gnome.gnome-tweaks
    discord
    nextcloud-client
    alacritty
    rnote
    joplin-desktop
    xournalpp
    vscode-fhs
    texlive.combined.scheme-medium
    ffmpeg

    microsoft-edge
    floorp
];

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "floorp";
    TERMINAL = "alacritty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11"; # Please read the comment before changing.
}
