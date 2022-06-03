local opt = vim.opt
local g = vim.g

g.mapleader = ' '

opt.undofile = true
opt.undodir = "${HOME}/.cache/"

opt.smartindent = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.clipboard = "unnamedplus"

opt.mouse = "a"

opt.termguicolors = true
opt.cursorline = true
opt.number = true

opt.viminfo = ""
opt.viminfofile = "NONE"

opt.smartcase = true
opt.ttimeoutlen = 5
opt.compatible = false
opt.autoread = true
opt.incsearch = true
opt.hidden = true
