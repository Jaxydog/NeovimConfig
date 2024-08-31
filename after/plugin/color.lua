local hl_group = 'SelectLineNr'
local hl_partial_group = 'PartialSelectLineNr'
local hl_namespace = vim.api.nvim_create_namespace('hl-' .. hl_group)

require('catppuccin').setup({
    custom_highlights = function(colors)
        return {
            CursorLineNr = { bold = true },

            [hl_partial_group] = {
                foreground = colors.lavender,
                background = colors.surface0,
            },
            [hl_group] = {
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

local function hl_bounds(start_row, start_col, stop_row, stop_col)
    return {
        start = start_row - 1,
        stop = stop_row - 1,
        start_partial = start_col > 1,
        stop_partial = stop_col < vim.fn.charcol({ stop_row, '$' }) - 1
    }
end


local function hl_select_line_nr(event)
    local visual_modes = { 'v', 'V', '<C-V>' }

    vim.api.nvim_buf_clear_namespace(event.buf, hl_namespace, 0, -1)

    local mode = vim.api.nvim_get_mode().mode

    if not vim.tbl_contains(visual_modes, mode) then return end

    local _, cursor_row, cursor_col = unpack(vim.fn.getpos('.'))
    local _, select_row, select_col = unpack(vim.fn.getpos('v'))

    local hl

    if cursor_row >= select_row then
        hl = hl_bounds(select_row, select_col, cursor_row, cursor_col)
    else
        hl = hl_bounds(cursor_row, cursor_col, select_row, select_col)
    end

    for line = hl.start, hl.stop, 1 do
        local partial = false

        if line == hl.start then partial = partial or hl.start_partial end
        if line == hl.stop then partial = partial or hl.stop_partial end

        local group = (mode ~= 'V' and partial) and hl_partial_group or hl_group

        vim.api.nvim_buf_set_extmark(event.buf, hl_namespace, line, 0, { number_hl_group = group })
    end
end

vim.api.nvim_create_autocmd({ 'CursorMoved', 'ModeChanged' }, {
    group = vim.api.nvim_create_augroup('hl_select_line_nr', {}),
    desc = 'Add highlighting to the numbers for selected lines',
    callback = hl_select_line_nr,
})

function SetTheme(color)
    color = color or 'catppuccin-mocha'

    vim.cmd.colorscheme(color)
end

SetTheme()
