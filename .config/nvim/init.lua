vim.cmd.colorscheme('sorbet')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '

-- QoL
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- Indents
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4

-- Search
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true

-- Visuals
vim.o.ruler = true
vim.o.showmatch = true
vim.o.termguicolors = true
vim.o.colorcolumn = '121'
vim.o.signcolumn = 'yes'
vim.o.winborder = 'rounded'

-- Files
vim.o.autoread = true
vim.o.autowrite = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.expand('~/.vim/undodir')

-- Behavior
vim.o.autochdir = false
vim.o.hidden = true
vim.o.modifiable = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.encoding = 'UTF-8'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.mouse = 'a'

-- Plugins
vim.pack.add({
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'lua',
        'python',
        'c',
        'java',
        'rust',
        'go',
        'zig'
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
require('nvim-tree').setup()

-- LSP
vim.lsp.enable({
    'lua_ls',
    'pyright',
    'ruff',
    'clangd',

})
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
            }
        }
    }
})
vim.lsp.inlay_hint.enable(true)

-- Keymap
vim.keymap.set('i', 'jk', '<C-[>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

local tele_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tele_builtin.find_files)
vim.keymap.set('n', '<leader>fg', tele_builtin.live_grep)
vim.keymap.set('n', '<leader>fb', tele_builtin.buffers)
vim.keymap.set('n', '<leader>fh', tele_builtin.help_tags)
