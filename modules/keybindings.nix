# 快捷键配置模块
{ ... }:

{
  extraConfigLua = builtins.readFile ./lua/keybindings.lua;
}
