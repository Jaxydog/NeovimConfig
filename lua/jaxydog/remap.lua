vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<leader>,', require('jaxydog.utility').split_terminal)
vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format()

    local success, conform = pcall(require, 'conform')

    if success then conform.format() end
end)
