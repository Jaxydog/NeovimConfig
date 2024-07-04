function SetTheme(color)
    color = color or 'catppuccin-mocha'

    vim.cmd.colorscheme(color)
end

SetTheme()
