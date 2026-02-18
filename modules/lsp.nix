# LSP 和 语言支持配置
{ pkgs, ... }:

{
  # LSP 服务器和工具
  extraPackages = with pkgs; [
    # Lua
    lua-language-server
    stylua

    # C/C++
    clang-tools

    # Bash
    nodePackages.bash-language-server

    # Markdown
    marksman

    # Python
    pyright
    ruff

    # TypeScript/JavaScript
    vtsls

    # Dart
    dart

    # Nix
    nil

    # 通用工具
    ripgrep
    fd
    fzf
    lazygit
    tree-sitter
  ];

  extraConfigLua = builtins.readFile ./lua/lsp.lua;
}
