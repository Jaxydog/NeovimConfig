local function split_terminal(options)
    options = options or {}

    local command = vim.trim(options['command'] or vim.fn.input('Command: '))
    local with_args = options['with_args']

    if with_args == nil then with_args = true end

    if command == '' then
        print('Cancelled')

        return
    end

    if with_args and options['command'] then
        local arguments = vim.trim(vim.fn.input('Arguments: '))

        if arguments ~= '' then command = command .. ' ' .. arguments end
    end

    print('Running \'' .. command .. '\'')

    vim.api.nvim_command('set splitright | vs | term ' .. command)
end

return { split_terminal = split_terminal }
