vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<leader>,', require('jaxydog.utility').split_terminal)
vim.keymap.set('n', '<leader>f', function()
    local success, conform = pcall(require, 'conform')

    if success and #conform.list_formatters(0) ~= 0 then
        conform.format()
    else
        vim.lsp.buf.format()
    end
end)
