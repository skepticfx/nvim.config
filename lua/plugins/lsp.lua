return {
	-- LSP and Mason
	{ 'williamboman/mason.nvim', config = true }, -- Optional, Mason setup
	{ 'williamboman/mason-lspconfig.nvim', config = true }, -- Mason-LSP setup
	{ 'neovim/nvim-lspconfig' }, -- LSP configuration
	{ 'folke/lazydev.nvim' }, -- Optional plugin for lazy development

	-- nvim-cmp and related plugins
	{ 'hrsh7th/nvim-cmp', dependencies = {
		'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
		'hrsh7th/cmp-buffer',   -- Buffer source
		'hrsh7th/cmp-path',     -- Path source
		'hrsh7th/cmp-cmdline',  -- Command-line source
	}},
}

