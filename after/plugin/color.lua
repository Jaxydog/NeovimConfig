local select_hl_group = 'CursorSelectNr'
local select_namespace = vim.api.nvim_create_namespace('hl-' .. select_hl_group)

require('catppuccin').setup({
    custom_highlights = function(colors)
        return {
            CursorLineNr = { bold = true },
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
            local _, cursor_row = unpack(vim.fn.getpos('.'))
            local _, select_row = unpack(vim.fn.getpos('v'))

            local hl_start = (cursor_row <= select_row and cursor_row or select_row) - 1
            local hl_end = (select_row >= cursor_row and select_row or cursor_row) - 1

            for line = hl_start, hl_end, 1 do
                vim.api.nvim_buf_set_extmark(event.buf, select_namespace, line, 0, {
                    number_hl_group = select_hl_group,
                })
            end
        end
    end
})

function SetTheme(color)
    color = color or 'catppuccin-mocha'

    vim.cmd.colorscheme(color)
end

SetTheme()
