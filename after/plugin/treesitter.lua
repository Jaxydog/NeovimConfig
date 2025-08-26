require('nvim-treesitter.configs').setup({
    ensure_installed = { 'bash', 'lua', 'markdown', 'markdown_inline', 'regex', 'rust', 'toml', 'vim', 'vimdoc' },
    ignore_install = {},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    modules = {},
})
