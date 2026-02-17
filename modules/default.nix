# 统一配置整合 - 合并所有模块输出
{ pkgs, lib, ... }:

let
  # 加载各个模块
  optionsModule = import ./options.nix { inherit lib; };
  pluginsModule = import ./plugins.nix { inherit pkgs; };
  lspModule = import ./lsp.nix { inherit pkgs; };
  uiModule = import ./ui.nix { };
  keybindingsModule = import ./keybindings.nix { };

  # 安全地提取值，如果不存在则返回默认值
  getList = attr: config: config.${attr} or [];
  getString = attr: config: config.${attr} or "";

  # 合并所有包依赖
  packages = lib.unique (
    (getList "extraPackages" pluginsModule) ++
    (getList "extraPackages" lspModule) ++
    (getList "extraPackages" uiModule) ++
    (getList "extraPackages" keybindingsModule)
  );

  # 合并所有插件
  plugins = 
    (getList "extraPlugins" pluginsModule) ++
    (getList "extraPlugins" lspModule) ++
    (getList "extraPlugins" uiModule) ++
    (getList "extraPlugins" keybindingsModule);

  # 合并所有 Lua 代码
  luaConfig = lib.concatStringsSep "\n" (lib.filter (s: s != "") [
    (getString "extraConfigLua" pluginsModule)
    (getString "extraConfigLua" lspModule)
    (getString "extraConfigLua" uiModule)
    (getString "extraConfigLua" keybindingsModule)
  ]);

in {
  inherit packages plugins luaConfig;
  opts = optionsModule.opts or {};
}
