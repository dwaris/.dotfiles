{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        mangohud

        lutris
        wineWowPackages.waylandFull

        ryujinx
        prismlauncher
    ];
}
