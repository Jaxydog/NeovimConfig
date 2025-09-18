require('nvim-treesitter.configs').setup({
    ensure_installed = { 'bash', 'regex', 'rust', 'toml' },
    ignore_install = {},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    modules = {},
})
