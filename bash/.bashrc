

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

export EDITOR=nvim
export PAGER="less -R"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

alias la='ls -lathr'
alias ll='ls -la'
alias ls='ls -a --color=auto'
alias mv='mv -v'
alias vim=nvim

if command -v fzf-share > /dev/null; then
  source "$(fzf-share)/key-bindings.bash"
  source "$(fzf-share)/completion.bash"
  eval "$(fzf --bash)"
elif command -v fzf > /dev/null; then # debians version of fzf us too old for --bash
  source /usr/share/doc/fzf/examples/key-bindings.bash
  source /usr/share/doc/fzf/examples/completion.bash
fi

eval "$(starship init bash --print-full-init)"

if command -v direnv > /dev/null; then
  eval "$(direnv hook bash)"
fi

eval "$(zoxide init bash)"

