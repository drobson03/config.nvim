local function biome_prettier_fallback(bufnr)
	if require("conform").get_formatter_info("prettierd", bufnr).available then
		return { "prettierd", lsp_fallback = false }
	elseif require("conform").get_formatter_info("biome", bufnr).available then
		return { "biome", lsp_fallback = false }
	end
end

return {
	{
		"stevearc/conform.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "n",
				desc = "Format",
			},
		},
		opts = {
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = {
				timeout_ms = 1000,
			},
			formatters_by_ft = {
				asm = { "asmfmt" },
				lua = { "stylua" },
				javascript = biome_prettier_fallback,
				typescript = biome_prettier_fallback,
				javscriptreact = biome_prettier_fallback,
				typescriptreact = biome_prettier_fallback,
				json = biome_prettier_fallback,
				jsonc = biome_prettier_fallback,
				css = { "prettierd" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				html = { "prettierd" },
				haskell = { "ormolu" },
				blade = { "prettierd" },
				php = { "prettierd" },
				astro = { "prettierd" },
				tex = { "latexindent" },
				markdown = { "prettierd" },
				mdx = { "prettierd" },
				xml = { "xmllint" },
			},
		},
	},
}
