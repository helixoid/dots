-- lua/plugins/treesitter.lua
vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', branch = 'main' },
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' then
      vim.cmd 'TSUpdate'
    end
  end,
})

-- install parsers on first launch
vim.schedule(function()
  require('nvim-treesitter').install { 'lua', 'rust', 'c', 'cpp', 'nix', 'python', 'zig', 'bash', 'markdown' }
end)

-- enable highlighting and indentation
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
