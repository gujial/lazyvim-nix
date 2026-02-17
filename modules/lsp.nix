# LSP 和 语言支持配置
{ pkgs, ... }:

{
  # LSP 服务器和工具
  extraPackages = with pkgs; [
    # Lua
    lua-language-server
    stylua
    
    # Bash
    nodePackages.bash-language-server
    
    # Markdown
    marksman
    
    # Python
    pyright
    ruff
    
    # TypeScript/JavaScript
    nodePackages.vtsls
    
    # 通用工具
    ripgrep
    fd
    fzf
    lazygit
    tree-sitter
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
    
    -- Bash LSP 配置
    lspconfig.bashls.setup({})
    
    -- Markdown LSP 配置
    lspconfig.marksman.setup({})
    
    -- Python LSP 配置
    lspconfig.pyright.setup({
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          }
        }
      }
    })
    
    -- Ruff LSP 配置
    lspconfig.ruff.setup({})
    
    -- TypeScript/JavaScript LSP 配置
    lspconfig.vtsls.setup({})
  '';
}
