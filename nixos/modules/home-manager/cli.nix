{ config, pkgs, ... }: {
    home.packages = with pkgs; [
        alacritty
        neovim
        tmux
        starship
        btop
        bottom
        fzf
        fd
        ripgrep
        htop
        rsync
        wget2
        curl
        stow
        unzip
        bash-completion
        neofetch
    ];
}
