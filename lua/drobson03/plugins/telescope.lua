return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>pf",
			function()
				require("telescope.builtin").find_files()
			end,
			mode = "n",
			desc = "Telescope: Find Files",
		},
		{
			"<C-p>",
			function()
				require("telescope.builtin").git_files()
			end,
			mode = "n",
			desc = "Telescope: Git Files",
		},
		{
			"<leader>ps",
			function()
				require("telescope.builtin").live_grep({
					additional_args = { "--hidden" },
				})
			end,
			mode = "n",
			desc = "Telescope: Live Grep",
		},
		{
			"<leader>vh",
			function()
				require("telescope.builtin").help_tags()
			end,
			mode = "n",
			desc = "Telescope: Help Tags",
		},
	},
	config = true,
}
