{ config, pkgs, lib, ... }: {
    home.packages = with pkgs; [
        stow
        nixfmt-classic
        black
        stylua
    ];
    programs.bash.enable = true;
    programs.fzf.enable = true;
    programs.zoxide.enable = true;

    programs.bash.shellAliases = {
        ".." = "cd ..";
        ls="ls -a --color=auto";
        ll="ls -la";
        la="ls -lathr";
        mv="mv -v";
        vim="nvim";
    };
    programs.bash.historyIgnore = ["ls" "cd" "exit" "clear"];
    programs.bash.historyControl = ["erasedups" "ignoredups" "ignorespace"];
}
