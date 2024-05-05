{ config, lib, pkgs, ...}: {
    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        redhat-official-fonts
        (nerdfonts.override { fonts = [ "SourceCodePro" "FiraCode" ]; })
    ];
}
