require("lazy").setup({
	defaults = {
		lazy = true,
	},
	dev = {
		path = "@LAZY_PLUGINS_PATH@",
		patterns = { "" },
		fallback = true,
	},
	rocks = {
		enabled = false,
	},
	spec = { -- LazyVim 核心
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = {
				colorscheme = "catppuccin-mocha",
			},
		}, -- Catppuccin 主题
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			opts = {
				flavour = "mocha",
			},
		}, -- 关闭默认 yanky 与系统剪贴板环的同步，避免 KDE/Klipper 焦点干扰
		{
			"gbprod/yanky.nvim",
			optional = true,
			opts = {
				system_clipboard = {
					sync_with_ring = false,
				},
			},
		}, -- 模糊查找
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			enabled = true,
		}, -- ltex Extra 词典
		{
			"barreiroleo/ltex_extra.nvim",
			ft = { "markdown", "tex", "text" },
			dependencies = { "neovim/nvim-lspconfig" },
			config = function()
				-- config 本身运行于触发懒加载的 FileType 事件中，需立即关闭当前缓冲区
				vim.opt_local.spell = false

				vim.api.nvim_create_autocmd("FileType", {
					pattern = { "markdown", "tex", "text" },
					callback = function()
						-- 延迟到 LazyVim 自身的 FileType 自动命令（会开启 spell）执行之后
						vim.schedule(function()
							vim.opt_local.spell = false
						end)
					end,
				})

				require("lspconfig").ltex.setup({
					filetypes = { "markdown", "tex", "text" },
					settings = {
						ltex = {
							language = "en-US",
							completionEnabled = true,
						},
					},
					on_attach = function()
						-- 在 LSP 客户端附加到缓冲区后初始化 ltex_extra
						require("ltex_extra").setup({
							load_langs = { "en-US", "zh-CN" },
							init_check = true,
							path = vim.fn.stdpath("config") .. "/ltex",
						})
					end,
				})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			opts = {
				-- 安装 Snacks.image 文档渲染相关 parser
				ensure_installed = { "css", "latex", "norg", "scss", "svelte", "typst", "vue" },
				auto_install = true,

				-- 启用高亮
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				-- 启用增量选择
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},

				-- 启用缩进
				indent = {
					enable = true,
				},
			},
		}, -- direnv
		{
			"NotAShelf/direnv.nvim",
			opts = {},
		}, -- snacks.nvim 文件浏览器
		{
			"folke/snacks.nvim",
			opts = {
				image = {
					enabled = true,
				},
				picker = {
					hidden = true,
					ignored = true,
					win = {
						-- 1. 配置结果列表（左侧/中间的选择列表）
						list = {
							wo = {
								number = true, -- 显示行号
								relativenumber = true, -- 显示相对行号
							},
						},
						-- 2. 配置预览窗口（右侧的内容预览）
						preview = {
							wo = {
								number = true, -- 预览中显示行号
								relativenumber = true, -- 预览中显示相对行号
							},
						},
					},
					sources = {
						files = {
							hidden = true, -- 显示隐藏文件（以 . 开头）
							ignored = true, -- 显示 .gitignore 中的文件
						},
					},
				},
			},
		}, -- 任务运行器
		{
			"stevearc/overseer.nvim",
			opts = {
				dap = true,
				task_list = {
					bindings = {
						["?"] = "ShowHelp",
						["g?"] = "ShowHelp",
						["<CR>"] = "RunAction",
						["<C-e>"] = "Edit",
						["o"] = "Open",
						["<C-v>"] = "OpenVsplit",
						["<C-s>"] = "OpenSplit",
						["<C-f>"] = "OpenFloat",
						["<C-q>"] = "OpenQuickFix",
						["p"] = "TogglePreview",
						["<C-l>"] = "IncreaseDetail",
						["<C-h>"] = "DecreaseDetail",
						["L"] = "IncreaseAllDetail",
						["H"] = "DecreaseAllDetail",
						["["] = "DecreaseWidth",
						["]"] = "IncreaseWidth",
						["{"] = "PrevTask",
						["}"] = "NextTask",
						["<C-k>"] = "ScrollOutputUp",
						["<C-j>"] = "ScrollOutputDown",
					},
				},
			},
			keys = {
				{
					"<leader>ow",
					"<cmd>OverseerToggle<cr>",
					desc = "Task list",
				},
				{
					"<leader>oo",
					"<cmd>OverseerRun<cr>",
					desc = "Run task",
				},
				{
					"<leader>oq",
					"<cmd>OverseerQuickAction<cr>",
					desc = "Quick action",
				},
				{
					"<leader>oi",
					"<cmd>OverseerInfo<cr>",
					desc = "Task info",
				},
				{
					"<leader>ob",
					"<cmd>OverseerBuild<cr>",
					desc = "Build task",
				},
				{
					"<leader>ot",
					"<cmd>OverseerTaskAction<cr>",
					desc = "Task action",
				},
				{
					"<leader>oc",
					"<cmd>OverseerClearCache<cr>",
					desc = "Clear cache",
				},
			},
		}, -- DAP 调试配置
		{
			"mfussenegger/nvim-dap",
			dependencies = {
				"rcarriga/nvim-dap-ui",
				"theHamsta/nvim-dap-virtual-text",
				"nvim-neotest/nvim-nio",
				"stevearc/overseer.nvim",
			},
			config = function()
				local dap = require("dap")
				local dapui = require("dapui")

				-- 初始化 DAP UI，配置布局选项
				dapui.setup({
					layouts = {
						{
							elements = {
								{
									id = "scopes",
									size = 0.25,
								},
								{
									id = "breakpoints",
									size = 0.25,
								},
								{
									id = "stacks",
									size = 0.25,
								},
								{
									id = "watches",
									size = 0.25,
								},
							},
							size = 40,
							position = "left",
						},
						{
							elements = {
								{
									id = "repl",
									size = 0.5,
								},
								{
									id = "console",
									size = 0.5,
								},
							},
							size = 10,
							position = "bottom",
						},
					},
				})

				-- 保存窗口布局的变量
				local saved_layout = nil

				-- DAP 事件监听 - 保存和恢复窗口布局
				dap.listeners.after.event_initialized["dapui_config"] = function()
					-- 保存当前窗口布局
					local ok, layout = pcall(vim.fn.winrestcmd)
					if ok and layout and type(layout) == "string" and layout ~= "" then
						saved_layout = layout
					end
					dapui.open()
				end

				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close()
					-- 恢复窗口布局
					if saved_layout and type(saved_layout) == "string" and saved_layout ~= "" then
						vim.defer_fn(function()
							pcall(vim.cmd, saved_layout)
							saved_layout = nil
						end, 50)
					end
				end

				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close()
					-- 恢复窗口布局
					if saved_layout and type(saved_layout) == "string" and saved_layout ~= "" then
						vim.defer_fn(function()
							pcall(vim.cmd, saved_layout)
							saved_layout = nil
						end, 50)
					end
				end

				-- C/C++ 调试配置 (GDB)
				dap.configurations.cpp = {
					{
						name = "Launch - GDB",
						type = "cppdbg",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "$${workspaceFolder}",
						stopOnEntry = false,
						args = {},
						runInTerminal = true,
					},
					{
						name = "Attach to Process - GDB",
						type = "cppdbg",
						request = "attach",
						processId = require("dap.utils").pick_process,
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "$${workspaceFolder}",
					},
					{
						name = "Launch - CodeLLDB",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "$${workspaceFolder}",
						stopOnEntry = false,
						args = {},
						runInTerminal = true,
					},
				}

				-- C 调试配置使用相同的配置
				dap.configurations.c = dap.configurations.cpp

				-- 调试适配器配置
				dap.adapters.cppdbg = {
					id = "cppdbg",
					type = "executable",
					command = "@GDB_PATH@/gdb",
					args = { "-i", "dap" },
					options = {
						detached = false,
					},
				}

				dap.adapters.codelldb = {
					type = "server",
					port = "$${port}",
					executable = {
						command = "@LLDB_PATH@/lldb",
						args = { "--mi" },
					},
				}

				dap.adapters.gdb = {
					type = "executable",
					command = "@GDB_PATH@/gdb",
					args = { "-i", "mi" },
				}

				-- JavaScript/TypeScript 调试适配器
				dap.adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "$${port}",
					executable = {
						command = "node",
						args = { "@VSCODE_JS_DEBUG_PATH@/out/src/dapDebugServer.js", "$${port}" },
					},
				}
				dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]
				dap.adapters["pwa-msedge"] = dap.adapters["pwa-node"]
				dap.adapters.node = dap.adapters["pwa-node"]
				dap.adapters.chrome = dap.adapters["pwa-node"]
				dap.adapters.msedge = dap.adapters["pwa-node"]

				-- Python 调试适配器
				dap.adapters.python = function(cb, config)
					if config.request == "attach" then
						local port = (config.connect or config).port
						local host = (config.connect or config).host or "127.0.0.1"
						cb({
							type = "server",
							port = assert(port, "`connect.port` is required for a python `attach` configuration"),
							host = host,
							options = {
								source_filetype = "python",
							},
						})
					else
						cb({
							type = "executable",
							command = "python3",
							args = { "-m", "debugpy.adapter" },
							options = {
								source_filetype = "python",
							},
						})
					end
				end

				-- Python 调试配置
				dap.configurations.python = {
					{
						type = "python",
						request = "launch",
						name = "Launch file",
						program = "$${file}",
						pythonPath = function()
							return "python3"
						end,
					},
				}

				-- 虚拟文本配置
				require("nvim-dap-virtual-text").setup({
					enabled = true,
					enabled_commands = true,
					highlight_changed_variables = true,
					highlight_new_as_changed = false,
					show_stop_reason = true,
					commented = false,
					only_frames = false,
					all_frames = false,
					virt_text_pos = "eol",
					all_references = false,
					filter_references_pattern = "<module",
					virt_lines = false,
					virt_text_win_col = nil,
				})
			end,
			keys = {
				{
					"<leader>du",
					function()
						require("dapui").toggle()
					end,
					desc = "Dap UI",
				},
				{
					"<leader>de",
					function()
						require("dapui").eval()
					end,
					desc = "Eval",
					mode = { "n", "v" },
				},
			},
		}, -- mason
		{
			"mason-org/mason-lspconfig.nvim",
			enabled = false,
		},
		{
			"mason-org/mason.nvim",
			enabled = false,
		}, -- C# 格式化
		{
			"stevearc/conform.nvim",
			opts = function(_, opts)
				opts.formatters_by_ft = opts.formatters_by_ft or {}
				opts.formatters_by_ft.cs = { "dotnet_format" }

				opts.formatters = opts.formatters or {}
				opts.formatters.dotnet_format = {
					command = "dotnet",
					args = function(_, ctx)
						local search_opts = {
							path = vim.fs.dirname(ctx.filename),
							upward = true,
							type = "file",
						}

						local workspace = vim.fs.find(function(name)
							return name:match("%.sln$")
						end, search_opts)[1]

						if not workspace then
							workspace = vim.fs.find(function(name)
								return name:match("%.csproj$")
							end, search_opts)[1]
						end

						local args = { "format" }

						if workspace then
							table.insert(args, workspace)
						end

						vim.list_extend(args, { "--include", ctx.filename })
						return args
					end,
					stdin = false,
					require_cwd = true,
				}
			end,
		},
		{
			"apyra/nvim-unity-sync",
			lazy = false,
			config = function()
				require("unity.plugin").setup()
			end,
		}, -- LeetCode 插件
		{ "nvim-tree/nvim-tree.lua" },
		{
			"kawre/leetcode.nvim",
			build = ":TSUpdate html",
			cmd = "Leet",
			opts = {
				cn = {
					enabled = true,
					translator = true,
					translate_problems = true,
				},
				dependencies = { "folke/snacks.nvim" },
				lang = "cpp",
				picker = {
					provider = "snacks-picker",
				},
				image_support = true,
			},
		},
	},
})
