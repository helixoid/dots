-- run TSUpdate after install/update
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

-- enable highlighting and indentation per filetype
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- install parsers on startup (skips already-installed ones)
local ensure_installed = {
	"bash",
	"c",
	"cpp",
	"fish",
	"ini",
	"lua",
	"markdown",
	"nix",
	"python",
	"rust",
	"zig",
}
local installed = require("nvim-treesitter.parsers").get_parser_configs()
for _, lang in ipairs(ensure_installed) do
	if not installed[lang] then
		vim.cmd("TSInstall " .. lang)
	end
end
