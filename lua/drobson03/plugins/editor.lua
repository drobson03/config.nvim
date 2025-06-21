return {
	{
		"lewis6991/gitsigns.nvim",
		config = true
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			exclude = {
				filetypes = {
					"help",
					"Trouble",
					"lazy",
					"mason",
				},
			},
		},
	},
	{
		"laytan/cloak.nvim",
		config = function()
			local cloak = require("cloak")
			cloak.setup()

			vim.keymap.set("n", "<leader>cc", function()
				cloak.toggle()
			end, { desc = "Toggle cloak" })
		end,
	},
	"tpope/vim-sleuth",
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		opts = {
			file_types = { "markdown", "mdx" },
		},
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
	}
}
