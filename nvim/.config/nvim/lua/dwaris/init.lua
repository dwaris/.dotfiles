require 'dwaris.lazy'
require 'dwaris.keymaps'

local opt = vim.opt

opt.expandtab = true
opt.hlsearch = true
opt.number = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv 'HOME' .. '/.nvim/undodir'
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 8
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = 'menuone,noselect'
opt.termguicolors = true

opt.list = true
opt.listchars = 'tab:→ ,trail:·,extends:>,precedes:<'
opt.inccommand = 'split'
opt.splitright = true
opt.splitbelow = true
opt.cursorline = true
opt.showmode = false

opt.shiftwidth = 4
opt.tabstop = 4
