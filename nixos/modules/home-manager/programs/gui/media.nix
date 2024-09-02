{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        plexamp
        plex-desktop
        mpv
        vlc
        tauon
        tidal-hifi
    ];
}
