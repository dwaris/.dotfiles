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
        marksman
        lua-language-server
        nil
        black
        stylua
    ];
}
