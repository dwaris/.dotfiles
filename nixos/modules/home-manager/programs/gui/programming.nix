{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        neovide

        vscode-fhs
        zed-editor
    ];
}
