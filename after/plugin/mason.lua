local lsp = require('lsp-zero')

require('mason').setup({})

require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'markdown_oxide', 'rust_analyzer' },
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
        end,
        markdown_oxide = function()
            local client_capabilities = vim.lsp.protocol.make_client_capabilities()
            local capabilities = require('cmp_nvim_lsp').default_capabilities(client_capabilities)

            capabilities.workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            }

            require('lspconfig').markdown_oxide.setup({
                on_attach = lsp.on_attach,
                capabilities = capabilities,
            })
        end,
        rust_analyzer = function()
            require('lspconfig').rust_analyzer.setup({
                on_attach = lsp.on_attach,
                settings = { ['rust-analyzer'] = { checkOnSave = { command = 'clippy' } } }
            })
        end,
    },
})
