return {
    {
        'williamboman/mason.nvim',
    },
    {
        'williamboman/mason-lspconfig.nvim',
    },
    {
        'zapling/mason-lock.nvim',
        opts = {
            lockfile_path = vim.fn.stdpath('config') .. '/mason-lock.json'
        }
    },
}
