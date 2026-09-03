# UI 和 主题配置
_: {
  # 使用 LazyVim 默认主题配置
  env = {
    SNACKS_KITTY = "true";
  };

  extraConfigLua = builtins.readFile ./lua/ui.lua;
}
