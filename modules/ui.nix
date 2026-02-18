# UI 和 主题配置
{ ... }:

{
  # 使用 LazyVim 默认主题配置
  extraConfigLua = builtins.readFile ./lua/ui.lua;
}
