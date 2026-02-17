# Treesitter 配置
{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    tree-sitter
  ];

  extraConfigLua = ''
    -- Treesitter 配置
    require('nvim-treesitter.configs').setup({
      -- 禁用自动安装（由 Nix 管理）
      ensure_installed = {},
      auto_install = false,
      
      -- 启用高亮
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      
      -- 启用增量选择
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      
      -- 启用缩进
      indent = {
        enable = true,
      },
    })
  '';
}
