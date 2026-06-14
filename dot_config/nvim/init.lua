-- [[ Setting the leader key ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("keymaps")
require("options")
require("plugins.colorscheme")
require("plugins.completions")
require("plugins.fff")
require("plugins.formatter")
require("plugins.lsp")
require("plugins.snacks")
require("plugins.treesitter")
