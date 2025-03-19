#== ZINIT INSTALLATION ============================================
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
		print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"

# Enable Zinit autocompletion
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

#####################
# ENVIRONMENT       #
#####################
HISTCONTROL=erasedups:ignoredups:ignorespace
HISTFILESIZE=100000
HISTIGNORE="ls:cd:exit:clear"
HISTSIZE=10000

export EDITOR=nvim
export PAGER="less -R"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Enable Starship prompt
eval "$(starship init zsh)"

#####################
# ZSH SETTINGS      #
#####################
setopt promptsubst globdots histignoredups sharehistory appendhistory
setopt hist_ignore_all_dups hist_reduce_blanks hist_save_no_dups
setopt extendedglob autocd nocaseglob notify nomatch correctall
setopt histappend checkjobs

# Keybindings (use Vim mode)
bindkey -v  
export KEYTIMEOUT=1

#####################
# ALIASES           #
#####################
alias la='ls -lathr'
alias ll='ls -la'
alias ls='ls -a --color=auto'
alias mv='mv -v'
alias vim=nvim

##########################
# OMZ Libraries & Plugins
##########################
zinit wait lucid for \
  OMZL::history.zsh \
  OMZL::clipboard.zsh \
  OMZL::compfix.zsh \
  OMZL::completion.zsh \
  OMZL::correction.zsh \
  OMZL::directories.zsh \
  OMZL::git.zsh \
  OMZL::grep.zsh \
  OMZL::key-bindings.zsh \
  OMZL::spectrum.zsh \
  OMZP::git \
  OMZP::fzf \
  OMZP::sudo \
  OMZP::tmux \
  hlissner/zsh-autopair \

#####################
# ADDITIONAL PLUGINS
#####################
zinit wait lucid for \
  hlissner/zsh-autopair \
  zsh-users/zsh-autosuggestions \
    atinit"ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20 ZSH_AUTOSUGGEST_STRATEGY=(history completion)" \
    atload"_zsh_autosuggest_start" \
  zdharma-continuum/fast-syntax-highlighting \
    atinit"zpcompinit; zpcdreplay" \
  zdharma-continuum/history-search-multi-word \
    atinit"
      zstyle ':completion:*' completer _expand _complete _ignored _approximate
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' menu select=2
      zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm,cmd -w -w'
      zstyle ':completion:*:descriptions' format '-- %d --'
      zstyle ':completion:*:processes' command 'ps -au$USER'
      zstyle ':completion:complete:*:options' sort false
      zstyle ':fzf-tab:complete:_zlua:*' query-string input
      zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'ls -1 --color=always ${~ctxt[hpre]}$in'
      zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap" \
    blockf light-mode \
  zsh-users/zsh-completions \
    atinit"
      zstyle :history-search-multi-word page-size 10
      zstyle :history-search-multi-word highlight-color fg=red,bold
      zstyle :plugin:history-search-multi-word reset-prompt-protect 1" \
    bindmap"^R -> ^H" \
  zdharma-continuum/history-search-multi-word \
  Aloxaf/fzf-tab

#####################
# UTILITIES         #
#####################
eval "$(direnv hook zsh)"

# Ensure completions work correctly; open shell faster with cache
if [ "$(find ~/.zcompdump -mtime 1)" ] ; then
    compinit
fi
compinit -C

# Enable job notifications
setopt CHECK_JOBS

# must be added after compinit is called
eval "$(zoxide init zsh)"
