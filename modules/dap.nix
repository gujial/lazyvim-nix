# DAP (Debug Adapter Protocol) 调试配置
{ pkgs, ... }:

{
  # 调试相关的包
  extraPackages = with pkgs; [
    gdb           # GNU 调试器
    lldb          # LLVM 调试器
    vscode-js-debug  # JavaScript/TypeScript 调试器
  ];

  # DAP 插件
  extraPlugins = with pkgs.vimPlugins; [
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
  ];

  # DAP Lua 配置
  extraConfigLua = ''
    -- DAP 配置
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

    -- C++ 调试配置 (GDB)
    dap.configurations.cpp = {
      {
        name = "Launch - GDB",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "''${workspaceFolder}",
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
        cwd = "''${workspaceFolder}",
      },
    }

    -- C 调试配置使用相同的配置
    dap.configurations.c = dap.configurations.cpp

    -- 如果有 CodeLLDB 扩展，也可以配置 LLDB
    dap.configurations.cpp = vim.list_extend(dap.configurations.cpp, {
      {
        name = "Launch - CodeLLDB",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "''${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        runInTerminal = true,
      },
    })

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

    -- CodeLLDB 适配器
    dap.adapters.codelldb = {
      type = "server",
      port = "''${port}",
      executable = {
        command = "${pkgs.lldb}/bin/lldb",
        args = {"--mi"},
      }
    }

    -- GDB 适配器（简单配置）
    dap.adapters.gdb = {
      type = "executable",
      command = "${pkgs.gdb}/bin/gdb",
      args = {"-i", "mi"},
    }

    -- JavaScript/TypeScript 调试适配器
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "''${port}",
      executable = {
        command = "${pkgs.vscode-js-debug}/bin/js-debug-adapter",
        args = { "''${port}" },
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
        program = "''${file}",
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
  '';
}
