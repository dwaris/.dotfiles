{ config, pkgs, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dwaris";
  home.homeDirectory = "/home/dwaris";

  nixpkgs = {
	config = {
  		allowUnfree = true;
      		allowUnfreePredicate = (_: true);
 
		};
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
    neofetch
    sqlite
    python3Full
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
    unzip
    vlc
  ];

  home.file = {
    ".config/alacritty" = {
      source = ./.dotfiles/alacritty/.config/alacritty;
      recursive = true;
    };
    ".bashrc".source = ./.dotfiles/bash/.bashrc;
    ".inputrc".source = ./.dotfiles/bash/.inputrc;
    ".config/starship/starship.toml".source = ./.dotfiles/bash/.config/starship.toml;
    ".config/nvim" = {
      source = ./.dotfiles/nvim/.config/nvim;
      recursive = true;
    };
    ".tmux.conf".source = ./.dotfiles/tmux/.tmux.conf;
    ".vimrc".source = ./.dotfiles/vim/.vimrc;
    ".ssh/config".source = ./.dotfiles/private/ssh/.ssh/config;
    ".gitconfig".source = ./.dotfiles/private/git/.gitconfig;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05"; # Please read the comment before changing.
}
