

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTCONTROL=erasedups:ignoredups:ignorespace
HISTFILESIZE=100000
HISTIGNORE=ls:cd:exit:clear
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

alias ..='cd ..'
alias la='ls -lathr'
alias ll='ls -la'
alias ls='ls -a --color=auto'
alias mv='mv -v'
alias vim=nvim

#if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
#  source /run/current-system/sw/share/fzf/completion.bash
#  source /run/current-system/sw/share/fzf/key-bindings.bash
#fi

if command -v fzf-share >/dev/null; then
  source "$(fzf-share)/key-bindings.bash"
  source "$(fzf-share)/completion.bash"
fi

eval "$(fzf --bash)"

eval "$(zoxide init bash )"

eval "$(starship init bash --print-full-init)"

eval "$(direnv hook bash)"


