return {
    -- Markdown rendering.
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },
        opts = {
            completions = {
                lsp = {
                    enabled = true,
                },
            },
        },
    },

    -- Code screenshots.
    {
        'michaelrommel/nvim-silicon',
        cmd = 'Silicon',
        main = 'nvim-silicon',
        lazy = true,
        opts = {
            font = 'Fira Code=32;Noto Color Emoji=32',
            theme = 'Catppuccin Mocha',
            line_offset = function(args) return args.line1 end,
            to_clipboard = true,
            wslclipboard = 'auto',
            wslclipboardcopy = 'keep',
        },
    }
}
