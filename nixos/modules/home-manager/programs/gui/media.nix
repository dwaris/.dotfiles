{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        plex-media-player
        plexamp
        mpv
        vlc
        tidal-hifi
    ];
}
