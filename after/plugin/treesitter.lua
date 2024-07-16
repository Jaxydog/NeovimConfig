require('nvim-treesitter.configs').setup({
    ensure_installed = { 'bash', 'lua', 'markdown', 'markdown_inline', 'regex', 'rust', 'toml', 'vim', 'vimdoc' },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
