local lsp = require('lsp-zero')
local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({}),
})

lsp.extend_lspconfig({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    float_border = 'rounded',
    sign_text = true,
    lsp_attach = function(client, buffer)
        lsp.default_keymaps({ buffer = buffer })

        if client.supports_method('textDocument/formatting') then
            lsp.buffer_autoformat()
        end
    end,
})

lsp.set_sign_icons({
    error = '!',
    warn = '?',
    hint = '~',
    info = 'i',
})
