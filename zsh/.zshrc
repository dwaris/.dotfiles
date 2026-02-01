#== ZINIT INSTALLATION ============================================
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
		print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"

#####################
# ENVIRONMENT       #
#####################
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR=nvim
export PAGER="less -R"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

#####################
# COMPLETION INIT   #
#####################
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
   compinit
else
   compinit -C
fi

##########################
# PLUGINS
##########################
eval "$(starship init zsh)"

zinit wait lucid for \
  OMZL::history.zsh \
  OMZL::compfix.zsh \
  OMZL::completion.zsh \
  OMZL::key-bindings.zsh \
  OMZL::directories.zsh \
  OMZL::correction.zsh \
  OMZL::git.zsh \
  OMZL::grep.zsh \
  OMZP::git \
  OMZP::sudo \
  OMZP::fzf

zinit wait lucid for \
  hlissner/zsh-autopair \
  zsh-users/zsh-autosuggestions \
  zdharma-continuum/history-search-multi-word \
  blockf zsh-users/zsh-completions \
  Aloxaf/fzf-tab

#####################
# SYNTAX HIGHLIGHTING
#####################
zinit wait lucid for \
 atinit"zpcompinit; zpcdreplay" \
 zdharma-continuum/fast-syntax-highlighting

#####################
# ALIASES           #
#####################
alias la='ls -lathr'
alias ll='ls -la'
alias ls='ls -a --color=auto'
alias mv='mv -v'
alias vim=nvim

#####################
# KEYBINDINGS       #
#####################
bindkey -v
export KEYTIMEOUT=1
