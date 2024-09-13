{ config, pkgs, ... }:
let
  username = "dwaris";
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dwaris = {
    isNormalUser = true;
    description = "dwaris";
    extraGroups = [ "wheel" ];
  };

  nix.settings.trusted-users = [ username ];

  nix.settings = {
    # enable flakes globally
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    builders-use-substitutes = true;
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  # Configure console keymap
  console.keyMap = "us";

  services.openssh = {
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
    allowSFTP = true; # Don't set this if you need sftp
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget2
    curl
    git
    sysstat
    lm_sensors

    # archives
    zip
    unzip
    unrar
    p7zip

    # utils
    ripgrep
    htop
    btop

    bottom
    fd
    fastfetch

    # transfer
    rsync

    #encoding
    parallel
    ffmpeg_7
    opusTools
    mkvtoolnix
    obs-studio

    #browser
    firefox
    chromium
    tor-browser

    #backup
    vorta
    nextcloud-client

    #game launcher
    mangohud

    lutris
    wineWowPackages.waylandFull

    ryujinx
    prismlauncher

    #media
    plexamp
    plex-desktop
    mpv
    vlc
    tauon
    tidal-hifi

    #messanger
    element-desktop
    signal-desktop
    telegram-desktop
    vesktop

    #office
    rnote
    joplin-desktop
    obsidian
    xournalpp

    inkscape
    gimp
    krita
    pixelorama

    #privacy
    bitwarden-desktop
    veracrypt
    protonvpn-gui

    #code
    vscode-fhs
    neovim

    #3d print
    prusa-slicer

    #vr
    alvr
    sidequest

    #vim
    nil
    nixfmt-rfc-style
    black
    stylua
    gopls
    pyright
    marksman
    lua-language-server
  ];
}
