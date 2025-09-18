local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazy_path,
    })
end

vim.opt.rtp:prepend(lazy_path)

require('jaxydog.init')
require('lazy').setup({
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        opts = {
            integrations = {
                mason = true,
            },
        },
    },
    {
        'xiyaowong/transparent.nvim',
        lazy = false,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        command = 'TSUpdate',
    },
    {
        'williamboman/mason.nvim',
    },
    {
        'williamboman/mason-lspconfig.nvim',
    },
    {
        'zapling/mason-lock.nvim',
        init = function()
            require('mason-lock').setup()
        end
    },
    {
        'neovim/nvim-lspconfig',
    },
    {
        'hrsh7th/cmp-nvim-lsp',
    },
    {
        'hrsh7th/nvim-cmp',
        opts = function(_, opts)
            opts.sources = opts.sources or {}

            table.insert(opts.sources, {
                name = 'lazydev',
                group_index = 0,
            })
        end,
    },
    {
        'mfussenegger/nvim-jdtls',
    },
    {
        'mfussenegger/nvim-dap',
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        lazy = false,
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                path = 'luvit-meta/library',
                words = { 'vim%.uv' },
            },
        },
    },
    {
        'Bilal2453/luvit-meta',
        lazy = true,
    },
    {
        'stevearc/conform.nvim',
        opts = {},
    },
    {
        'michaelrommel/nvim-silicon',
        lazy = true,
        cmd = 'Silicon',
        main = 'nvim-silicon',
        config = function()
            require('nvim-silicon').setup({
                font = 'Fira Code=32;Noto Color Emoji=32',
                theme = 'Catppuccin Mocha',
                line_offset = function(args) return args.line1 end,
                to_clipboard = true,
                wslclipboard = 'auto',
                wslclipboardcopy = 'keep',
            })
        end,
    },
    {
        'ellisonleao/glow.nvim',
        lazy = true,
        cmd = 'Glow',
        config = true,
    },
})
