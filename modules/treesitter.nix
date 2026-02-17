# Treesitter 配置
{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    tree-sitter
  ];

  # Treesitter 配置由 LazyVim 管理，不需要额外的 Lua 配置
  extraConfigLua = "";
}
