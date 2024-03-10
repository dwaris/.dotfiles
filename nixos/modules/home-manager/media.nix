{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        plex-media-player
        plexamp
        easyeffects
        mpv
    ];
}
