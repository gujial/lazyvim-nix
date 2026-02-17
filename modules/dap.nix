# DAP (Debug Adapter Protocol) 调试配置
{ pkgs, ... }:

{
  # 调试相关的包
  extraPackages = with pkgs; [
    gdb           # GNU 调试器
    lldb          # LLVM 调试器
    lldb-mi       # LLDB 机器接口（可选）
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
      command = "${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools-*/debugAdapters/bin/OpenDebugAD7",
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
