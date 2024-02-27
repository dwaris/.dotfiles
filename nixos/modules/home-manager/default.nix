{ config, pkgs, ... }: {
    imports = [
        ../home-manager/cli.nix
        ../home-manager/gnome.nix
        ../home-manager/browsers.nix
        ../home-manager/messenger.nix
        ../home-manager/office.nix
    ];

    home.packages = with pkgs; [
        vlc
        vscode-fhs
        texlive.combined.scheme-medium
    ];
}
