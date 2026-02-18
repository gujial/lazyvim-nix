require("lazy").setup({
	defaults = { lazy = true },
	dev = {
		path = "@LAZY_PLUGINS_PATH@",
		patterns = { "" },
		fallback = true,
	},
	rocks = {
		enabled = false,
	},
	spec = {
		-- LazyVim 核心
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },

		-- 模糊查找
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			enabled = true,
		},

		-- ltex Extra 词典
		{
			"barreiroleo/ltex_extra.nvim",
			ft = { "markdown", "tex", "text" },
			dependencies = { "neovim/nvim-lspconfig" },
			config = function()
				-- 手动配置 LTEX LSP
				require("lspconfig").ltex.setup({
					filetypes = { "markdown", "tex", "text" },
					settings = {
						ltex = {
							language = "zh-CN",
							completionEnabled = true,
						},
					},
					on_attach = function(client, bufnr)
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
			"zbirenbaum/copilot.lua",
			opts = {
				suggestion = {
					auto_trigger = true,
				},
			},
		},

		{
			"CopilotC-Nvim/CopilotChat.nvim",
			opts = {},
			dependencies = { "zbirenbaum/copilot.lua" },
			event = "VeryLazy",
		},

		-- 语法树
		{
			"nvim-treesitter/nvim-treesitter",
			opts = {
				-- 禁用自动安装（由 Nix 管理）
				ensure_installed = {},
				auto_install = false,

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
		},

		-- direnv
		{ "NotAShelf/direnv.nvim", opts = {} },

		-- snacks.nvim 文件浏览器
		{
			"folke/snacks.nvim",
			opts = {
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
		},

		-- 任务运行器
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
				{ "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "Task list" },
				{ "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
				{ "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick action" },
				{ "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Task info" },
				{ "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build task" },
				{ "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
				{ "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
			},
		},

		-- DAP 调试配置
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
								{ id = "scopes", size = 0.25 },
								{ id = "breakpoints", size = 0.25 },
								{ id = "stacks", size = 0.25 },
								{ id = "watches", size = 0.25 },
							},
							size = 40,
							position = "left",
						},
						{
							elements = {
								{ id = "repl", size = 0.5 },
								{ id = "console", size = 0.5 },
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
		},

		-- mason
		{ "mason-org/mason-lspconfig.nvim", enabled = false },
		{ "mason-org/mason.nvim", enabled = false },

		-- nvim-treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
		},

		-- LeetCode 插件
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
				dependencies = {
					"folke/snacks.nvim",
				},
				lang = "cpp",
				picker = { provider = "snacks-picker" },
			},
		},
	},
})
