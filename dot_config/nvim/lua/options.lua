-- Setting the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

-- Line Numbering Settings
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = true
opt.signcolumn = 'yes'

-- Tab Settings
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.shiftround = true
opt.smartindent = true

-- Search Settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- QOL Settings
opt.winborder = 'rounded'
opt.showmode = false
opt.clipboard = 'unnamedplus'
opt.timeoutlen = 300
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true

-- Buffer Settings
opt.undofile = true
opt.list = true
opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}
opt.inccommand = 'split'
opt.scrolloff = 10
opt.foldmethod = 'indent'
opt.foldlevel = 99
opt.foldenable = false

-- Enable the experimental UI2 subsystem
require('vim._core.ui2').enable {}

-- Diagnostics Icons in the gutter
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '󰌵',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
  virtual_lines = {
    current_line = true,
  },
  virtual_text = false,
}
