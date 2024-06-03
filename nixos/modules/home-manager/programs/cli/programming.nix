{ config, pkgs, ... }: {
    home.packages = with pkgs; [
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
