{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        stow
        neovim
        starship
        fzf
        bash-completion
    ];
}
