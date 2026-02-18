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
  extraConfigLua = 
    let
      luaConfig = builtins.readFile ./lua/plugins.lua;
    in
    builtins.replaceStrings
      [
        "@LAZY_PLUGINS_PATH@"
        "@GDB_PATH@"
        "@LLDB_PATH@"
        "@VSCODE_JS_DEBUG_PATH@"
      ]
      [
        "${pkgs.linkFarm "lazy-plugins" [ ]}"
        "${pkgs.gdb}/bin"
        "${pkgs.lldb}/bin"
        "${pkgs.vscode-js-debug}"
      ]
      luaConfig;
}
