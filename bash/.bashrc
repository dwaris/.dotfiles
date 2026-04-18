# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTCONTROL=erasedups:ignoredups:ignorespace
HISTFILESIZE=100000
HISTIGNORE=ls:cd:exit:clear
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s checkjobs
shopt -s globstar 2>/dev/null 

export PAGER="less -R"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim
    alias vim='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR=vim
else
    export EDITOR=vi
    alias vim='vi'
fi

# --- ALIASES ---
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -lathr'
alias mv='mv -v'

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

if command -v fzf-share >/dev/null 2>&1; then
    source "$(fzf-share)/key-bindings.bash"
    source "$(fzf-share)/completion.bash"
    eval "$(fzf --bash)"
elif command -v fzf >/dev/null 2>&1; then 
    # Fallback for Debian/Ubuntu older versions
    [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]] && source /usr/share/doc/fzf/examples/key-bindings.bash
    [[ -f /usr/share/doc/fzf/examples/completion.bash ]] && source /usr/share/doc/fzf/examples/completion.bash
fi

[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash --print-full-init)"
fi