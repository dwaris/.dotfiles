{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        plexamp
        mpv
        vlc
        tidal-hifi
    ];
}
