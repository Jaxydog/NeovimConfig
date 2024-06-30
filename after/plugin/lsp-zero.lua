local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, buffer)
    lsp.default_keymaps({ buffer = buffer })

    if client.supports_method('textDocument/formatting') then
        lsp.buffer_autoformat()
    end
end)

lsp.set_sign_icons({
    error = '!',
    warn = '?',
    hint = '~',
    info = 'i',
})
