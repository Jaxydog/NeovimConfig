local root_file_names = { '.git', 'build.gradle', 'gradle.properties', 'gradlew', 'README.md', 'settings.gradle' }

local paths = {}

paths.share = vim.fs.joinpath(vim.fn.expand('$MASON'), 'share', 'jdtls')
paths.launcher = vim.fs.joinpath(paths.share, 'plugins', 'org.eclipse.equinox.launcher.jar')
paths.config = vim.fs.joinpath(paths.share, 'config')
paths.codestyle = vim.fs.joinpath(vim.fn.stdpath('config'), 'codestyle', 'java.xml')
paths.cache = vim.fs.joinpath(vim.fn.stdpath('cache'), 'nvim-jdtls', vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'))

local jdtls = require('jdtls')

jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

jdtls.start_or_attach({
    capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities() or {},
        require('cmp_nvim_lsp').default_capabilities() or {}
    ),
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.level=ALL',
        '-Dlog.protocol=true',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', paths.launcher,
        '-configuration', paths.config,
        '-data', paths.cache,
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    flags = { allow_incremental_sync = true },
    on_attach = function(_, buffer)
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = buffer,
            group = vim.api.nvim_create_augroup('jdtls-ext', { clear = true }),
            desc = 'Formats the current buffer on write.',
            callback = function()
                jdtls.organize_imports()
                vim.lsp.buf.format()
            end,
        })
    end,
    root_dir = vim.fs.root(0, root_file_names),
    settings = {
        configuration = { updateBuildConfiguration = 'interactive' },
        contentProvider = { preferred = 'fernflower' },
        eclipse = { downloadSources = true },
        format = {
            enabled = true,
            settings = { profile = paths.codestyle },
        },
        maven = { downloadSources = true },
        signatureHelp = { enabled = true },
    },
})
