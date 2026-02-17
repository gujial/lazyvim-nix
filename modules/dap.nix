# DAP (Debug Adapter Protocol) 调试配置
{ pkgs, ... }:

{
  # 调试相关的包
  extraPackages = with pkgs; [
    gdb           # GNU 调试器
    lldb          # LLVM 调试器
    vscode-js-debug  # JavaScript/TypeScript 调试器
    nodejs        # Node.js（用于运行 js-debug-adapter）
  ];

  # DAP 配置将由 lazy.nvim 在 plugins.nix 中管理
  extraConfigLua = "";
}

