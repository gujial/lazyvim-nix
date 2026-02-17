# 插件配置管理
{ pkgs, ... }:

{
  # 基础依赖
  extraPackages = with pkgs; [
    lua-language-server
    stylua
    ripgrep
  ];

  # 核心插件
  extraPlugins = [ pkgs.vimPlugins.lazy-nvim ];

  # LazyVim 插件规范配置
  extraConfigLua = ''
    require("lazy").setup({
      defaults = { lazy = true },
      dev = {
        path = "${pkgs.linkFarm "lazy-plugins" []}",
        patterns = { "" },
        fallback = true,
      },
      -- 禁用 luarocks 支持（由 Nix 管理）
      rocks = {
        enabled = false,
      },
      spec = {
        -- LazyVim 核心
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        
        -- 模糊查找
        { 
          "nvim-telescope/telescope-fzf-native.nvim", 
          enabled = true 
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
          }
        },

        -- direnv
        { "NotAShelf/direnv.nvim", opts = {} },

        -- DAP 调试配置
        {
          "mfussenegger/nvim-dap",
          dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
          },
          config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- 初始化 DAP UI
            dapui.setup()

            -- DAP 事件监听
            dap.listeners.after.event_initialized["dapui_config"] = function()
              dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
              dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
              dapui.close()
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
              command = "${pkgs.gdb}/bin/gdb",
              args = {"-i", "dap"},
              options = {
                detached = false
              }
            }

            dap.adapters.codelldb = {
              type = "server",
              port = "$${port}",
              executable = {
                command = "${pkgs.lldb}/bin/lldb",
                args = {"--mi"},
              }
            }

            dap.adapters.gdb = {
              type = "executable",
              command = "${pkgs.gdb}/bin/gdb",
              args = {"-i", "mi"},
            }

            -- JavaScript/TypeScript 调试适配器
            dap.adapters["pwa-node"] = {
              type = "server",
              host = "localhost",
              port = "$${port}",
              executable = {
                command = "node",
                args = { "${pkgs.vscode-js-debug}/out/src/dapDebugServer.js", "$${port}" },
              }
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
              virt_text_win_col = nil
            })
          end,
          keys = {
            { "<leader>du", function() require("dapui").toggle() end, desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
          }
        },
        
        -- 禁用 mason（由 nix 管理）
        { "mason-org/mason-lspconfig.nvim", enabled = false },
        { "mason-org/mason.nvim", enabled = false },
      },
    })
  '';
}
