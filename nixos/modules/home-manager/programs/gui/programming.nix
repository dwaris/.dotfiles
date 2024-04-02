{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        neovide

        vscode-fhs
    ];
}
