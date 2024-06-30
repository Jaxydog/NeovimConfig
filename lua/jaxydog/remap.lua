vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format() end)
vim.keymap.set('n', '<leader>,', require('jaxydog.utility').split_terminal)
