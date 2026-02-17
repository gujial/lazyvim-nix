# 快捷键配置模块
{ ... }:

{
  extraConfigLua = ''
    -- 设置 leader 键
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"
    
    -- 基础快捷键配置
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }
    
    -- 窗口导航
    keymap("n", "<C-h>", "<C-w>h", opts)
    keymap("n", "<C-j>", "<C-w>j", opts)
    keymap("n", "<C-k>", "<C-w>k", opts)
    keymap("n", "<C-l>", "<C-w>l", opts)
    
    -- 窗口大小调整
    keymap("n", "<C-Up>", ":resize +2<CR>", opts)
    keymap("n", "<C-Down>", ":resize -2<CR>", opts)
    keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
    keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
    
    -- 缓冲区导航
    keymap("n", "<S-l>", ":bnext<CR>", opts)
    keymap("n", "<S-h>", ":bprevious<CR>", opts)
    
    -- 注释：具体的快捷键配置应该通过 LazyVim 来管理
    -- 这里只提供基础的导航快捷键
  '';
}
