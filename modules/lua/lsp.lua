-- LSP 配置
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

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

-- Python LSP 配置
lspconfig.pyright.setup({
	cmd = { "pyright-langserver", "--stdio" },
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
lspconfig.ruff.setup({
	cmd = { "ruff", "server" },
})

-- TypeScript/JavaScript LSP 配置
lspconfig.vtsls.setup({})

-- Dart LSP 配置
lspconfig.dartls.setup({})

-- Java LSP 配置
local function jdtls_workspace_dir(root_dir)
	return vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fs.basename(root_dir)
end

lspconfig.jdtls.setup({
	cmd = {
		"@JDTLS_PATH@",
		"--jvm-arg=-javaagent:@LOMBOK_JAR@",
	},
	root_dir = util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts"),
	on_new_config = function(new_config, new_root_dir)
		new_config.cmd = {
			"@JDTLS_PATH@",
			"--jvm-arg=-javaagent:@LOMBOK_JAR@",
			"-data",
			jdtls_workspace_dir(new_root_dir),
		}
	end,
})

-- Nix LSP 配置
lspconfig.nil_ls.setup({
	cmd = { "nil" },
})

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

-- C# LSP 配置
lspconfig.csharp_ls.setup({
	cmd = { "csharp-ls" },
})
