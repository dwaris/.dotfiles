if has('filetype')
  filetype indent plugin on
  endif

if has('syntax')
  syntax on
endif

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set clipboard=unnamedplus

set nowrap

set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

set nohlsearch
set incsearch
set ignorecase
set smartcase

set termguicolors

set scrolloff=8
set signcolumn=yes
set updatetime=50
set cursorline
set noshowmode
set colorcolumn=80
if has('mouse')
  set mouse=a
endif

highlight Comment ctermfg=green
highlight LineNr ctermfg=darkgrey
