return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")
		oil.setup({
			columns = { "icon" },
			view_options = {
				show_hidden = true,
			},
			skip_confirm_for_simple_edits = true,
			keymaps = {
				["<C-p>"] = false,
			}
		})

		vim.keymap.set("n", "-", oil.open)
	end,
}
