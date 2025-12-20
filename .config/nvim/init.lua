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

-- Behavior
vim.o.autochdir = false
vim.o.hidden = true
vim.o.modifiable = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.encoding = 'UTF-8'
vim.o.mouse = 'a'

-- Plugins
vim.pack.add({
    { src = 'https://github.com/catppuccin/nvim' },
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/hiphish/rainbow-delimiters.nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope-frecency.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter',         build = ':TSUpdate' },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    { src = 'https://github.com/rbong/vim-flog' },
    { src = 'https://github.com/saghen/blink.cmp',                        version = vim.version.range('1.*') },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/windwp/nvim-autopairs' },
})
vim.cmd.colorscheme('tokyonight')
vim.o.statusline = '%<%f %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%) %P'
require('telescope').setup()
require('telescope').load_extension('frecency')
require('telescope').load_extension('fzf')
require('nvim-treesitter').install({
    'lua',
    'python',
    'c',
    'java',
    'rust',
    'go',
    'zig',
})
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
require('gitsigns').setup({
    current_line_blame = true,
    on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gs.nav_hunk('next')
            end
        end)
        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gs.nav_hunk('prev')
            end
        end)

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<leader>hr', gs.reset_hunk)
        map('v', '<leader>hs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map('v', '<leader>hr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hi', gs.preview_hunk_inline)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function()
            gs.diffthis('~')
        end)
    end,
})
require('nvim-autopairs').setup({
    disable_filetype = { 'TelescopePrompt', 'vim' },
    map_cr = true,
    check_ts = true,
})
require('nvim-tree').setup({
    on_attach = function(bufnr)
        local nvimtree_api = require('nvim-tree.api')
        nvimtree_api.config.mappings.default_on_attach(bufnr)
    end,
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
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
            },
            telemetry = {
                enable = false,
            },
        }
    }
})
vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('RuffAutoOrganize', { clear = true }),
    pattern = '*.py',
    callback = function()
        vim.lsp.buf.code_action({
            context = {
                only = { 'source.organizeImports' },
            },
            apply = true,
        })
    end,
})
vim.diagnostic.config({
    update_in_insert = true,
    float = {
        focusable = false,
        source = true,
    },
})
vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertLeave' }, {
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
vim.keymap.set('n', '<leader>w', '<cmd>write<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>quit<CR>')
vim.keymap.set('n', '<leader>o', '<cmd>update | source<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

local tele_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tele_builtin.find_files)
vim.keymap.set('n', '<leader>fg', tele_builtin.live_grep)
vim.keymap.set('n', '<leader>fb', tele_builtin.buffers)
vim.keymap.set('n', '<leader>fh', tele_builtin.help_tags)
vim.keymap.set('n', '<leader>f/', tele_builtin.current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>gr', tele_builtin.lsp_references)
vim.keymap.set('n', '<leader>gd', tele_builtin.lsp_definitions)
vim.keymap.set('n', '<leader>ds', tele_builtin.lsp_document_symbols)
vim.keymap.set('n', '<leader>ws', tele_builtin.lsp_workspace_symbols)

local nvimtree_api = require('nvim-tree.api')
vim.keymap.set('n', '<C-n>', nvimtree_api.tree.toggle)
