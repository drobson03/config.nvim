local servers = {
	ocamllsp = {},
	hls = {},
	ccls = {},
	zls = {},
	ts_ls = {},
	rust_analyzer = {},
	tailwindcss = {
		settings = {
			tailwindCSS = {
				experimental = {
					classRegex = {
						"tw[cx]\\.[^`]+`([^`]*)`",
						"tw[cx]\\(.*?\\).*?`([^`]*)",
						{ "tw[cx]\\.[^`]+\\(([^)]*)\\)",     "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						{ "tw[cx]\\(.*?\\).*?\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					},
				},
			},
		},
	},
}

local on_attach = function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.jump({
			count = 1,
			float = true,
		})
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.jump({
			count = -1,
			float = true,
		})
	end, opts)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>vrr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {}
			},
			"mason-org/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			require("neodev").setup({
				override = function(_, library)
					library.enabled = true
					library.plugins = true
				end,
				pathStrict = false,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local mason_lspconfig = require("mason-lspconfig")

			servers = vim.tbl_extend("keep", servers, {
				lua_ls = {
					Lua = {
						workspace = {
							checkThirdParty = "Disable",
							library = {
								vim.fn.expand("$VIMRUNTIME"),
								require("neodev.config").types(),
							},
						},
						telemetry = { enable = false },
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})

			for server_name, server_config in pairs(servers) do
				vim.lsp.config(server_name, {
					on_attach = on_attach,
					capabilities = capabilities,
					settings = server_config,
				})
			end

			mason_lspconfig.setup()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")

			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<Tab>"] = nil,
					["<S-Tab>"] = nil,
				}),
				sources = {
					{ name = "nvim_lsp" },
				},
			})
		end,
	},
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({})
		end,
	},
	{
		"folke/trouble.nvim",
		keys = {
			{
				"<leader>vd",
				"<cmd>Trouble diagnostics toggle focus=false filter.buf=0<cr>",
				desc = "Diagnostics (Trouble)",
			},
		},
		cmd = { "Trouble" },
		opts = {},
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local refactoring = require("refactoring")
			refactoring.setup()

			vim.keymap.set({ "n", "x" }, "<leader>ri", function()
				refactoring.refactor("Inline Variable")
			end)

			vim.keymap.set("n", "<leader>rI", function()
				refactoring.refactor("Inline Function")
			end)
		end,
	},
	{
		"lervag/vimtex",
		ft = { "tex", "plaintex", "latex" },
		init = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_view_method = "zathura"
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			settings = {
				tsserver_max_memory = "8192",
			},
		},
	},
}
