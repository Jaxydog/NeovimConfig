local cmp = require('cmp')

cmp.setup({
    sources = { { name = 'nvim_lsp' } },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.confirm({ select = false }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    snippet = {
        expand = function(args) vim.snippet.expand(args.body) end,
    },
})

local lspconfig_defaults = require('lspconfig').util.default_config

lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

require('mason').setup()
require('mason-lspconfig').setup({
    automatic_installation = true,
    ensure_installed = { 'lua_ls' },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        clangd = function()
            require('lspconfig').clangd.setup({
                on_attach = function()
                    vim.keymap.set('n', '<leader>sh', vim.cmd.ClangdSwitchSourceHeader)
                end
            })
        end,
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = { Lua = {} },
                on_attach = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name

                        if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. './luarc.jsonc') then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = { version = 'LuaJIT' },
                        workspace = {
                            checkThirdParty = false,
                            library = { vim.env.VIMRUNTIME },
                        },
                    })
                end,
            })
        end,
        markdown_oxide = function()
            local client_capabilities = vim.lsp.protocol.make_client_capabilities()
            local capabilities = require('cmp_nvim_lsp').default_capabilities(client_capabilities)

            capabilities.workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            }

            require('lspconfig').markdown_oxide.setup({ capabilities = capabilities })
        end,
        rust_analyzer = function() end,
    },
})

require('conform').setup({
    formatters_by_ft = { markdown = { 'mdformat' } },
    format_on_save = {},
})

vim.g.rustaceanvim = {
    tools = {
        enable_clippy = true,
        test_executor = 'background',
    },
    server = {
        capabilities = lspconfig_defaults,
        default_settings = { ['rust-analyzer'] = {} },
        on_attach = function()
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
    },
    dap = {},
}

vim.opt.signcolumn = 'yes'
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP action mappings',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end,
})

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '!',
            [vim.diagnostic.severity.WARN] = '?',
            [vim.diagnostic.severity.HINT] = '~',
            [vim.diagnostic.severity.INFO] = 'i',
        },
    },
})

local buffer_autoformat = function(buffer)
    local group = 'lsp_autoformat'

    vim.api.nvim_create_augroup(group, { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = buffer })

    vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = buffer,
        group = group,
        desc = 'LSP formatting on save',
        callback = function()
            vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
        end,
    })
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local id = vim.tbl_get(event, 'data', 'client_id')
        local client = id and vim.lsp.get_client_by_id(id)

        if client == nil then return end

        if client:supports_method('textDocument/formatting') then
            buffer_autoformat(event.buf)
        end
    end,
})
