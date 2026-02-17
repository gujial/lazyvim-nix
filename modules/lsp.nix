# LSP 和 语言支持配置
{ pkgs, ... }:

{
  # LSP 服务器和工具
  extraPackages = with pkgs; [
    # Lua
    lua-language-server
    stylua
    
    # 通用工具
    ripgrep
  ];

  extraConfigLua = ''
    -- LSP 配置
    local lspconfig = require('lspconfig')
    
    -- Lua LSP 配置
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }
          }
        }
      }
    })
  '';
}
