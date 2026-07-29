vim.loader.enable()

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
vim.o.shiftwidth = 4
vim.o.softtabstop = -1

-- Search
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- Visuals
vim.o.showmatch = true
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.colorcolumn = '121'
vim.o.matchtime = 1
vim.o.signcolumn = 'yes'
vim.o.winborder = 'single'

-- Files
vim.o.swapfile = false
vim.o.undofile = true

-- Behavior
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.maxmempattern = 2000000
vim.o.mouse = 'a'

-- Plugins
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then
                vim.cmd.packadd('nvim-treesitter')
            end
            vim.cmd('TSUpdate')
        end
    end,
})

vim.pack.add({
    -- Colorschemes
    { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/navarasu/onedark.nvim' },
    { src = 'https://github.com/rebelot/kanagawa.nvim' },
    -- Plugins
    { src = 'https://github.com/folke/snacks.nvim' },
    { src = 'https://github.com/hiphish/rainbow-delimiters.nvim' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-mini/mini.nvim' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
})

vim.cmd.colorscheme('kanagawa-wave')
-- require('onedark').setup({
--     style = 'cool',
--     toggle_style_key = '<leader>ts',
-- })
-- vim.cmd.colorscheme('onedark')

require('mason').setup()
require('mini.ai').setup()
require('mini.cmdline').setup()
require('mini.cursorword').setup()
require('mini.diff').setup({
    mappings = {
        apply = '<leader>hs',
        reset = '<leader>hr',
    },
    options = {
        wrap_goto = true,
    },
})
require('mini.git').setup()
require('mini.icons').setup()
require('mini.jump').setup()
require('mini.pairs').setup({
    modes = { command = true },
})
require('mini.snippets').setup()
require('mini.splitjoin').setup()
require('mini.statusline').setup()
require('mini.surround').setup()

require('snacks').setup({
    bigfile = { enabled = true },
    explorer = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
        matcher = {
            frecency = true,
            sort_empty = true,
        },
        sources = {
            explorer = {
                hidden = true,
                ignored = true,
                follow = true,
                exclude = {
                    '**/.git/*',
                    '**/.venv/*',
                },
                layout = { preview = true },
            },
            files = {
                hidden = true,
                ignored = true,
                follow = true,
                exclude = {
                    '**/.git/*',
                    '**/.venv/*',
                },
            },
            grep = {
                hidden = true,
                ignored = true,
                follow = true,
                exclude = {
                    '**/.git/*',
                    '**/.venv/*',
                },
            },
        },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    words = { enabled = true },
})

local ts_langs = {
    'asm',
    'bash',
    'c',
    'go',
    'haskell',
    'java',
    'json',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'python',
    'regex',
    'rust',
    'toml',
    'xml',
    'yaml',
    'zig',
}
require('nvim-treesitter').install(ts_langs)
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})
vim.filetype.add({
    extension = {
        nasm = 'asm',
    },
})
vim.treesitter.language.register('asm', 'asm')

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
    whitelist = ts_langs,
}

-- LSP
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.enable({
    'asm_lsp',
    'basedpyright',
    'clangd',
    'gopls',
    'java_language_server',
    'lua_ls',
    'ruff',
    'rust_analyzer',
    'ty',
    'zls',
})

vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('RuffAutoOrganize', { clear = true }),
    pattern = '*.py',
    callback = function()
        vim.lsp.buf.code_action({
            --- @diagnostic disable-next-line: missing-fields
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
    },
})

-- Keymap
vim.keymap.set('i', 'jk', '<C-[>')
vim.keymap.set('n', '<leader>w', '<cmd>write<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>quit<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
for _, op in ipairs({ 'c', 'C', 'd', 'D', 'p', 'P', 's', 'S', 'x', 'X', 'y', 'Y' }) do
    vim.keymap.set({ 'n', 'v' }, '<leader>' .. op, '"+' .. op)
end

vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end)
vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep() end)
vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers() end)
vim.keymap.set('n', '<leader>fh', function() Snacks.picker.help() end)
vim.keymap.set('n', '<leader>f/', function() Snacks.picker.lines() end)
vim.keymap.set('n', '<leader>gr', function() Snacks.picker.lsp_references() end)
vim.keymap.set('n', '<leader>gd', function() Snacks.picker.lsp_definitions() end)
vim.keymap.set('n', '<leader>gD', function() Snacks.picker.lsp_declarations() end)
vim.keymap.set('n', '<leader>gi', function() Snacks.picker.lsp_implementations() end)
vim.keymap.set('n', '<leader>ds', function() Snacks.picker.lsp_symbols() end)
vim.keymap.set('n', '<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end)
vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end)
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit.open() end)
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end)
vim.keymap.set('n', '<leader>gb', function() Snacks.git.blame_line() end)
vim.keymap.set('n', '<leader>gB', function() Snacks.gitbrowse() end)
vim.keymap.set('n', '<leader>n', function() Snacks.notifier.show_history() end)
vim.keymap.set('n', '<leader>un', function() Snacks.notifier.hide() end)
vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end)
vim.keymap.set('n', '<leader>cR', function() Snacks.rename.rename_file() end)
vim.keymap.set('n', ']]', function() Snacks.words.jump(vim.v.count1) end)
vim.keymap.set('n', '[[', function() Snacks.words.jump(-vim.v.count1) end)

vim.keymap.set('n', '<leader>hp', function() MiniDiff.toggle_overlay(0) end)
vim.keymap.set(
    'n',
    '<leader>hs',
    function() return MiniDiff.operator('apply') .. 'gh' end,
    { expr = true, remap = true }
)
vim.keymap.set(
    'n',
    '<leader>hr',
    function() return MiniDiff.operator('reset') .. 'gh' end,
    { expr = true, remap = true }
)
