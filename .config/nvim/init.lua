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
vim.o.matchtime = 1
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
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
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
    { src = 'https://github.com/Saghen/blink.cmp',                version = 'v1.8.0' },
    { src = 'https://github.com/windwp/nvim-autopairs' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/catppuccin/nvim' },
    { src = 'https://github.com/navarasu/onedark.nvim' },
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/Mofiqul/vscode.nvim' },
})
vim.cmd.colorscheme('catppuccin')
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'lua',
        'python',
        'c',
        'java',
        'rust',
        'go',
        'zig',
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
require('nvim-autopairs').setup({
    disable_filetype = { 'TelescopePrompt', 'vim' },
    map_cr = true,
    check_ts = true,
})

-- LSP
vim.lsp.enable({
    'lua_ls',
    'pyright',
    'ruff',
    'clangd',
    'java_language_server',
    'rust_analyzer',
    'gopls',
    'zls',
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
vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('RuffAutoOrganize', { clear = true }),
    pattern = '*.py',
    callback = function()
        vim.lsp.buf.code_action({
            ---@diagnostic disable-next-line: missing-fields
            context = {
                only = { 'source.organizeImports' },
            },
            apply = true,
        })
    end,
})
vim.lsp.config('ruff', {
    init_options = {
        settings = {
            configuration = 'C:\\Users\\Noah\\AppData\\Roaming\\ruff\ruff.toml',
            configurationPreference = 'filesystemFirst',
        }
    },
})
vim.diagnostic.config({
    float = {
        focusable = false,
        source = true,
    },
})
vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    callback = function()
        vim.diagnostic.open_float(nil, {
            scope = 'line',
            close_events = { 'CursorMoved', 'InsertEnter', 'WinLeave', 'BufLeave' },
        })
    end,
})
require('blink.cmp').setup({
    signature = {
        enabled = true,
    },
    completion = {
        documentation = {
            auto_show = true,
        },
    },
    keymap = {
        ['<Down>'] = { 'hide', 'fallback' },
        ['<Up>'] = { 'hide', 'fallback' },
        ['<Esc>'] = { 'hide', 'fallback' },
    }
})

-- Keymap
vim.keymap.set('i', 'jk', '<C-[>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

local tele_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tele_builtin.find_files)
vim.keymap.set('n', '<leader>fg', tele_builtin.live_grep)
vim.keymap.set('n', '<leader>fb', tele_builtin.buffers)
vim.keymap.set('n', '<leader>fh', tele_builtin.help_tags)
