# UI 和 主题配置
{ ... }:

{
  # 使用 LazyVim 默认主题配置
  extraConfigLua = ''
    -- UI 相关配置
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.cursorline = true
    vim.opt.termguicolors = true
    
    -- LazyVim 的主题系统会自动加载合适的主题
  '';
}
