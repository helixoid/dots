vim.lsp.enable({
	"clangd",
	"lua_ls",
	"nixd",
	"pyrefly",
	"rust_analyzer",
})

vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
})
