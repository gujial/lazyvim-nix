-- LSP 配置
local lspconfig = require("lspconfig")

-- Lua LSP 配置
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- Bash LSP 配置
lspconfig.bashls.setup({})

-- Latex LSP 配置
lspconfig.ltex.setup({
	filetypes = { "markdown", "tex", "text" },
	settings = {
		ltex = {
			language = "zh-CN",
		},
	},
})

-- Python LSP 配置
lspconfig.pyright.setup({
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
			},
		},
	},
})

-- Ruff LSP 配置
lspconfig.ruff.setup({})

-- TypeScript/JavaScript LSP 配置
lspconfig.vtsls.setup({})

-- Dart LSP 配置
lspconfig.dartls.setup({})

-- Nix LSP 配置
lspconfig.nil_ls.setup({})

-- C/C++ LSP 配置
lspconfig.clangd.setup({
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders=true",
	},
	capabilities = {
		offsetEncoding = { "utf-16" },
	},
})
