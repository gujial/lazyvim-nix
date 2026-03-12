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

    # C#
    csharp-ls
    dotnet-sdk_10
    dotnet-runtime_10

    # Bash
    nodePackages.bash-language-server

    # Latex
    ltex-ls
    icu

    markdownlint-cli2

    # Python
    pyright
    ruff

    # TypeScript/JavaScript
    vtsls

    # Dart
    dart

    # Java
    jdt-language-server
    jdk

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
