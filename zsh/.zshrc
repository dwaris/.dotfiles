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
zinit for \
  OMZL::history.zsh \
  OMZL::directories.zsh \
  OMZL::correction.zsh \
  OMZL::git.zsh \
  OMZL::grep.zsh \
  OMZP::git \
  OMZP::sudo

autoload -Uz compinit
if [[ -z ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zinit wait lucid for \
  hlissner/zsh-autopair \
  zsh-users/zsh-autosuggestions \
  bindmap"^R -> ^H" \
  zdharma-continuum/history-search-multi-word

zinit wait"1" lucid for \
  OMZP::fzf \
  blockf zsh-users/zsh-completions \
  Aloxaf/fzf-tab

# 5. Load Syntax Highlighting LAST
zinit lucid for \
  zdharma-continuum/fast-syntax-highlighting

#####################
# ALIASES           #
#####################
alias ls='eza --group-directories-first'
alias ll='eza -l --group-directories-first --git'
alias la='eza -la --group-directories-first --git'
alias lt='eza -la --sort=modified --reverse --group-directories-first --git'
alias tree='eza --tree --level=3'
alias cat='bat --style=plain --paging=never'
alias mv='mv -v'
alias less='bat --style=plain --paging=always'
alias vim=nvim

bindkey -v
export KEYTIMEOUT=1

eval "$(starship init zsh)"
