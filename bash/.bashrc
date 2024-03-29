#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s autocd cdspell direxpand dirspell globstar histappend histverify \
    nocaseglob no_empty_cmd_completion

alias ls='ls -a --color=auto'
alias ll='ls -la'
alias la='ls -lathr'
alias mv='mv -v'
alias vim=nvim

HISTCONTROL=ignoreboth:erasedups
HISTIGNORE=?:??
HISTSIZE=100000
SAVEHIST=100000
HISTCONTROL=ignorespace
PROMPT_COMMAND="history -a; history -n"

export VISUAL=nvim
export EDITOR=nvim
export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$PATH
export PAGER="less -R"
export EDITOR=nvim
export STARSHIP_CONFIG=~/.config/starship/starship.toml

if [ -f /usr/share/fzf/completion.bash ]; then
  source /usr/share/fzf/completion.bash
fi

if [ -f /usr/share/fzf/key-bindings.bash ]; then
  source /usr/share/fzf/key-bindings.bash
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
fi

if command -v fzf-share >/dev/null; then
  source "$(fzf-share)/key-bindings.bash"
  source "$(fzf-share)/completion.bash"
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
fi

# i can do it without this
#source $HOME/.fzf-tab-completion/bash/fzf-bash-completion.sh
#bind -x '"\C-f": fzf_bash_completion'


# Starship prompt
eval "$(starship init bash)"
function history_sharing() {
    history -a && history -n
}
starship_precmd_user_func="history_sharing"
