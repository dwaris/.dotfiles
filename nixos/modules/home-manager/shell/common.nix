{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        neovim
        tmux
        starship
        fzf
        bash-completion
    ];
}
