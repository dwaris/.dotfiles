{ config, pkgs, ... }: {
    imports = [
        ../home-manager/cli.nix
        ../home-manager/gnome.nix
        ../home-manager/programs/browsers.nix
        ../home-manager/messenger.nix
        ../home-manager/office.nix
    ];

    home.packages = with pkgs; [
        vorta
        veracrypt
        protonvpn-gui
        vlc
        vscode-fhs
        texlive.combined.scheme-medium
    ];
}
