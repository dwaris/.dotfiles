{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        gnumake
        cmake
        gcc
        rustup
        nodejs
        love
        go

        gopls
        marksman
        lua-language-server
        nil
        black
        stylua

        vscode-fhs
        texlive.combined.scheme-medium
    ];
}
