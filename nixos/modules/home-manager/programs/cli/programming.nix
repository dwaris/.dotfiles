{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        neovim

        gnumake
        cmake
        gcc
        rustup
        nodejs
        love
        go
        texlive.combined.scheme-medium

        gopls
        pyright
        marksman
        lua-language-server
        nil
    ];
}
