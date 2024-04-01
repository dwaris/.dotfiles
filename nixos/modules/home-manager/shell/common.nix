{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        stow
        neovim
        tmux
        starship
        fzf
        bash-completion
    ];
}
