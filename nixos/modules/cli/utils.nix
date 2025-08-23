{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # archive
    zip
    unzip
    unrar
    p7zip

    # network
    wget 
    
    # usage
    htop

    # copy
    rsync

    # misc
    fastfetch

    # new
    bat
    eza
    delta
    dust
    duf
    broot
    fd
    ripgrep
    fzf
    bottom
    zoxide
    doggo
    lazygit
  ];
}
