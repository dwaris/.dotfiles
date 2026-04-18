#== ZINIT INSTALLATION ============================================
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
		print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs

#####################
# ENVIRONMENT       #
#####################
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR=nvim
export PAGER="bat --plain --paging=always"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

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
  bindmap"^R -> ^H" \
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
alias ls='eza -a --icons=auto --group-directories-first --git'
alias ll='eza -la --icons=auto --group-directories-first --git'
alias la='eza -lah --sort=modified --reverse --icons=auto --group-directories-first --git'
alias cat='bat --style=plain --paging=never'
alias mv='mv -v'
alias vim=nvim

#####################
# KEYBINDINGS       #
#####################
bindkey -v
export KEYTIMEOUT=1
