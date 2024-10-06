local lsp = require('lsp-zero')

require('mason').setup({})

require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'markdown_oxide' },
    handlers = {
        lsp.default_setup,
        clangd = function()
            require('lspconfig').clangd.setup({
                on_attach = function(client, buffer)
                    vim.keymap.set('n', '<leader>sh', vim.cmd.ClangdSwitchSourceHeader)
                end
            })
        end,
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
        rust_analyzer = lsp.noop,
    },
})

vim.g.rustaceanvim = {
    tools = {
        enable_clippy = true,
        test_executor = 'background',
    },
    server = {
        capabilities = lsp.get_capabilities(),
        on_attach = function(client, buffer)
            vim.keymap.set('n', '<leader>-', function() vim.cmd.RustLsp('parentModule') end)

            vim.keymap.set({ 'n', 'v' }, '<leader>jl', function() vim.cmd.RustLsp('joinLines') end)

            vim.keymap.set({ 'n', 'v' }, '<leader>d', function() vim.cmd.RustLsp('renderDiagnostic') end)
            vim.keymap.set({ 'n', 'v' }, '<leader>D', function() vim.cmd.RustLsp('explainError') end)

            vim.keymap.set('n', '<leader>R', function() vim.cmd.RustLsp('rebuildProcMacros') end)
            vim.keymap.set({ 'n', 'v' }, '<leader>X', function() vim.cmd.RustLsp('expandMacro') end)

            vim.keymap.set('n', '<leader>hv', function() vim.cmd.RustLsp({ 'view', 'hir' }) end)
            vim.keymap.set('n', '<leader>mv', function() vim.cmd.RustLsp({ 'view', 'mir' }) end)

            vim.keymap.set({ 'n', 'v' }, '<leader><Up>', function() vim.cmd.RustLsp({ 'moveItem', 'up' }) end)
            vim.keymap.set({ 'n', 'v' }, '<leader><Down>', function() vim.cmd.RustLsp({ 'moveItem', 'down' }) end)
        end,
        default_settings = {
            ['rust-analyzer'] = {},
        },
    },
    dap = {},
}

require('conform').setup({
    formatters_by_ft = {
        markdown = { 'mdformat' },
    },
    format_on_save = {},
})
