return {
    -- LSP configuration plugins.
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

            table.insert(opts.sources, { name = 'lazydev', group_index = 0 })
        end
    },
    {
        'stevearc/conform.nvim',
        opts = {},
    },

    -- Lua LSP plugins.
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

    -- Rust LSP plugins.
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        lazy = false,
    },
    {
        'mfussenegger/nvim-dap',
    },

    -- Java LSP plugins.
    {
        'mfussenegger/nvim-jdtls'
    },
}
