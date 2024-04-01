{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        alacritty
        neovide

        vscode-fhs
    ];
}
