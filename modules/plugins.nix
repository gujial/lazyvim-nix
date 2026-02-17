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
  extraConfigLua = ''
    require("lazy").setup({
      defaults = { lazy = true },
      dev = {
        path = "${pkgs.linkFarm "lazy-plugins" []}",
        patterns = { "" },
        fallback = true,
      },
      spec = {
        -- LazyVim 核心
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        
        -- 模糊查找
        { 
          "nvim-telescope/telescope-fzf-native.nvim", 
          enabled = true 
        },
        
        -- 语法树（禁用 mason 自动安装）
        { 
          "nvim-treesitter/nvim-treesitter",
          opts = function(_, opts) 
            opts.ensure_installed = {} 
          end 
        },
        
        -- 禁用 mason（由 nix 管理）
        { "mason-org/mason-lspconfig.nvim", enabled = false },
        { "mason-org/mason.nvim", enabled = false },
      },
    })
  '';
}
