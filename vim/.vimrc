if has('filetype')
  filetype indent plugin on
endif

if has('syntax')
  syntax on
endif

if has('mouse')
  set mouse=a
endif

set clipboard=unnamedplus
set updatetime=50

set number
set ruler
set cursorline
set colorcolumn=80
set scrolloff=8
set nowrap
set noshowmode

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

set incsearch
set hlsearch
set ignorecase
set smartcase

set noswapfile
set nobackup
set undofile
set undodir=~/.vim/undodir

highlight Comment ctermfg=green
highlight LineNr ctermfg=darkgrey