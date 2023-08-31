if has('filetype')
  filetype indent plugin on
  endif

if has('syntax')
  syntax on
endif

set tabstop=4
set shiftwidth=4
set expandtab

set ignorecase
set smartcase

set ai
set number
set hlsearch
set ruler

set backspace=indent,eol,start
set autoindent
set nostartofline

set cmdheight=2
set wildmenu
set showcmd

if has('mouse')
  set mouse=a
endif

highlight Comment ctermfg=green
highlight LineNr ctermfg=darkgrey
