{ config, pkgs, ... }: {
    imports = [
        ../home-manager/cli.nix
    ];

    home.packages = with pkgs; [
    ];
}
