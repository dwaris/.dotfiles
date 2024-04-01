{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        vorta
        nextcloud-client
    ];
}
