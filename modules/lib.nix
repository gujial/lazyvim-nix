# 配置整合工具 - 合并模块化配置
{ lib }:

let
  # 合并多个 Nix 配置文件
  mergeConfigs = configs:
    lib.fold (a: b: a // b) {} configs;

  # 合并列表选项
  mergeListOptions = name: configs:
    lib.flatten (map (cfg: cfg.${name} or []) configs);

  # 合并 Lua 代码
  mergeLua = configs:
    lib.concatStringsSep "\n" (lib.flatten (map (cfg: cfg or []) configs));

in {
  inherit mergeConfigs mergeListOptions mergeLua;
}
