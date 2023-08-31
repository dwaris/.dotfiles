#== ZINIT ============================================
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
		print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
#=== ZINIT ============================================


#####################
# PROMPT            #
#####################
source ~/.zsh/variables.zsh
export STARSHIP_CONFIG=~/dotfiles/zsh/.zsh/starship.toml
eval "$(starship init zsh)"

##########################
# OMZ Libs and Plugins   #
##########################
setopt promptsubst globdots
zinit lucid for \
    atinit"
      ZSH_TMUX_FIXTERM=false
      ZSH_TMUX_AUTOSTART=true
      ZSH_TMUX_AUTOCONNECT=true" \
  OMZP::tmux \
  OMZL::history.zsh \

zinit wait lucid for \
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
  hlissner/zsh-autopair \

#####################
# PLUGINS           #
#####################
zinit wait lucid for \
    light-mode atinit"ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20 ZSH_AUTOSUGGEST_STRATEGY=(history completion)" atload"_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions \
    light-mode atinit"
      typeset -gA FAST_HIGHLIGHT; FAST_HIGHLIGHT[git-cmsg-len]=100;
      zpcompinit; zpcdreplay" \
  zdharma-continuum/fast-syntax-highlighting \
    atpull'zinit creinstall -q .' \
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

source ~/.zsh/aliases.zsh
