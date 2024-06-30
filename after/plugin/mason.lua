local lsp = require('lsp-zero')

require('mason').setup({})

require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'rust_analyzer' },
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
        end,
        rust_analyzer = function()
            require('lspconfig').rust_analyzer.setup({
                on_attach = lsp.on_attach,
                settings = { ['rust-analyzer'] = { checkOnSave = { command = 'clippy' } } }
            })
        end,
    },
})
