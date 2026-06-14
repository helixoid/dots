-- Coform.nvim Plugin Config.
require("conform").setup({
	formatters_by_ft = {
		css = { "biome-check" },
		fish = { "fish_indent" },
		javascript = { "biome-check" },
		json = { "biome-check" },
		jsonc = { "biome-check" },
		lua = { "stylua" },
		markdown = { "biome-check" },
		nix = { "alejandra" },
		python = { "ruff" },
		sh = { "shfmt" },
		toml = { "taplo" },
		yaml = { "yamlfmt" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = { timeout_ms = 500 },
	formatters = {
		shfmt = {
			prepend_args = { "-i", "2" },
		},
	},
})
