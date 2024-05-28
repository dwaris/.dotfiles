{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        plexamp
        mpv
        vlc
        tauon
        tidal-hifi
    ];
}
