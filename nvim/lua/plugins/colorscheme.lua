return {
	{
		lazy = true,
		"ellisonleao/gruvbox.nvim",
		opts = {
			transparent_mode = true,
		},
	},
	{
		lazy = true,
		"catppuccin/nvim",
		opts = {
			transparent_background = true,
		},
	},
	{
		lazy = true,
		"rose-pine/neovim",
		name = "rose-pine",
		opts = {
			styles = { transparency = true },
		},
	},

	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
		opts = {
			transparent = true,
		},
	},
	{
		"neanias/everforest-nvim",
		-- enabled = false,
		version = true,
		lazy = true,
		config = function(_, opts)
			require("everforest").setup({
				transparent_background_level = 1,
			})
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
		lazy = true,
		priority = 1000, -- Ensure it loads first
	},
	{
		"AlexvZyl/nordic.nvim",
		lazy = true,
		priority = 1000,
		opts = {
			transparent = {
				bg = true,
				float = true,
			},
		},
	},
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},

	{
		"ayu-theme/ayu-vim",
		lazy = true,
	},
	{
		"xero/miasma.nvim",
		lazy = true,
		priority = 1000,
	},
}
