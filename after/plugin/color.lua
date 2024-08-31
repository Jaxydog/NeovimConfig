local select_hl_group = 'CursorSelectNr'
local select_partial_hl_group = 'CursorPartialSelectNr'
local select_namespace = vim.api.nvim_create_namespace('hl-' .. select_hl_group)

require('catppuccin').setup({
    custom_highlights = function(colors)
        return {
            CursorLineNr = { bold = true },
            CursorPartialSelectNr = {
                bold = true,
                foreground = colors.lavender,
                background = colors.surface0,
            },
            CursorSelectNr = {
                bold = true,
                foreground = colors.lavender,
                background = colors.surface2,
            },

            DiagnosticUnderlineError = { undercurl = true },
            DiagnosticUnderlineWarn = { undercurl = true },
            DiagnosticUnderlineInfo = { undercurl = true },
            DiagnosticUnderlineHint = { undercurl = true },
        }
    end,
    integrations = { mason = true }
})

local cursor_select_hl_auto_group = vim.api.nvim_create_augroup('cursor_select_hl', {})

vim.api.nvim_create_autocmd({ 'CursorMoved', 'ModeChanged' }, {
    group = cursor_select_hl_auto_group,
    desc = 'Add highlighting to the numbers for selected lines',
    callback = function(event)
        local visual_modes = { 'v', 'V', '<C-V>' }
        local mode = vim.api.nvim_get_mode().mode

        vim.api.nvim_buf_clear_namespace(event.buf, select_namespace, 0, -1)

        if vim.tbl_contains(visual_modes, mode) then
            local _, cursor_row, cursor_col = unpack(vim.fn.getpos('.'))
            local _, select_row, select_col = unpack(vim.fn.getpos('v'))

            local hl = {}

            if cursor_row >= select_row then
                hl.start = select_row - 1
                hl.stop = cursor_row - 1
                hl.start_partial = select_col > 1
                hl.stop_partial = cursor_col < vim.fn.charcol('$') - 1
            else
                hl.start = cursor_row - 1
                hl.stop = select_row - 1
                hl.start_partial = cursor_col > 1
                hl.stop_partial = select_col < vim.fn.charcol({ select_row, '$' }) - 1
            end

            for line = hl.start, hl.stop, 1 do
                local partial = false

                if line == hl.start then partial = hl.start_partial end
                if line == hl.stop then partial = hl.stop_partial end

                local group = (mode ~= 'V' and partial) and select_partial_hl_group or select_hl_group

                vim.api.nvim_buf_set_extmark(event.buf, select_namespace, line, 0, { number_hl_group = group })
            end
        end
    end
})

function SetTheme(color)
    color = color or 'catppuccin-mocha'

    vim.cmd.colorscheme(color)
end

SetTheme()
