# 统一配置整合 - 合并所有模块输出
{ pkgs, lib, ... }:

let
  # 加载各个模块
  optionsModule = import ./options.nix { inherit lib; };
  pluginsModule = import ./plugins.nix { inherit pkgs; };
  lspModule = import ./lsp.nix { inherit pkgs; };
  dapModule = import ./dap.nix { inherit pkgs; };
  treesitterModule = import ./treesitter.nix { inherit pkgs; };
  optionalToolsModule = import ./optional-tools.nix { inherit pkgs; };
  uiModule = import ./ui.nix { };
  keybindingsModule = import ./keybindings.nix { };

  # 安全地提取值，如果不存在则返回默认值
  getList = attr: config: config.${attr} or [];
  getString = attr: config: config.${attr} or "";

  # 兼容部分插件 derivation 仅包含 name 而没有 pname 的情况
  normalizePlugin = plugin:
    if builtins.isAttrs plugin && (plugin ? overrideAttrs) && !(plugin ? pname) && (plugin ? name)
    then plugin.overrideAttrs (_: { pname = lib.getName plugin; })
    else plugin;

  # 合并所有包依赖
  packages = lib.unique (
    (getList "extraPackages" pluginsModule) ++
    (getList "extraPackages" lspModule) ++
    (getList "extraPackages" dapModule) ++
    (getList "extraPackages" treesitterModule) ++
    (getList "extraPackages" optionalToolsModule) ++
    (getList "extraPackages" uiModule) ++
    (getList "extraPackages" keybindingsModule)
  );

  # 合并所有插件
  plugins = map normalizePlugin (
    (getList "extraPlugins" pluginsModule) ++
    (getList "extraPlugins" dapModule) ++
    (getList "extraPlugins" treesitterModule) ++
    (getList "extraPlugins" lspModule) ++
    (getList "extraPlugins" uiModule) ++
    (getList "extraPlugins" keybindingsModule)
  );

  # 合并所有 Lua 代码
  luaConfig = lib.concatStringsSep "\n" (lib.filter (s: s != "") [
    (getString "extraConfigLua" treesitterModule)
    (getString "extraConfigLua" pluginsModule)
    (getString "extraConfigLua" dapModule)
    (getString "extraConfigLua" lspModule)
    (getString "extraConfigLua" uiModule)
    (getString "extraConfigLua" keybindingsModule)
  ]);

in {
  inherit packages plugins luaConfig;
  opts = optionsModule.opts or {};
}
