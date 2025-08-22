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
    lsd
    delta
    dust
    duf
    broot
    fd
    ripgrep
    fzf
    bottom
    procs
    zoxide
    doggo
    lazygit
  ];
}
