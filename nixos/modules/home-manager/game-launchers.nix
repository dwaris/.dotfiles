{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        heroic
        mangohud
        ryujinx
        osu-lazer
    ];
}
