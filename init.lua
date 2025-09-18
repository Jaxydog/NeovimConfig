local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazy_path) then
    local repository = 'https://github.com/folke/lazy.nvim.git'
    local output = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', repository, lazy_path })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n' },
            { output },
            { '\nPress any key to exit...' },
        }, true, { err = true })
    end
end

vim.opt.rtp:prepend(lazy_path)

require('jaxydog.init')
require('lazy').setup({
    install = {
        colorscheme = { 'catppuccin-mocha' },
    },
    checker = {
        enabled = true,
    },
    spec = {
        import = 'plugins',
    },
})
