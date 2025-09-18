return {
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
    },
    {
        'nvim-treesitter/nvim-treesitter',
        command = 'TSUpdate',
    }
}
