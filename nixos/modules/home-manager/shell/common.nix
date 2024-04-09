{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        stow
        starship
        fzf
        bash-completion
    ];
}
