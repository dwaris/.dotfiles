{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        heroic
        yuzu
    ];
}