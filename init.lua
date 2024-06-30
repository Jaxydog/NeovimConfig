local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazy_path,
	})
end

vim.opt.rtp:prepend(lazy_path)

require('jaxydog.init')
require('lazy').setup({
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		priority = 1000,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		command = 'TSUpdate',
	},
	{
		'williamboman/mason.nvim',
	},
	{
		'williamboman/mason-lspconfig.nvim',
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = "v3.x",
	},
	{
		'neovim/nvim-lspconfig',
	},
	{
		'hrsh7th/cmp-nvim-lsp',
	},
	{
		'hrsh7th/nvim-cmp',
	},
	{
		'L3MON4D3/LuaSnip',
	},
	{
		'michaelrommel/nvim-silicon',
		lazy = true,
		cmd = 'Silicon',
		main = 'nvim-silicon',
		config = function()
			require('nvim-silicon').setup({
				font = 'Fira Code=32;Noto Color Emoji=32',
				theme = 'Catppuccin Mocha'
			})
		end,
	},
	{
		'ellisonleao/glow.nvim',
		lazy = true,
		cmd = 'Glow',
		config = true,
	},
})
