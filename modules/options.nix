# 基础编辑器选项配置
{ lib, ... }:

{
  # 行号和视觉指示
  opts = {
    number = true;                    # 显示行号
    relativenumber = true;            # 相对行号
    cursorline = true;                # 高亮当前行
    cursorcolumn = false;             # 不高亮当前列
    
    # 制表符和缩进
    expandtab = true;                 # 使用空格而不是制表符
    tabstop = 2;                      # 制表符宽度
    shiftwidth = 2;                   # 缩进宽度
    softtabstop = 2;
    autoindent = true;
    
    # 搜索选项
    ignorecase = true;                # 不区分大小写搜索
    smartcase = true;                 # 智能大小写
    hlsearch = true;                  # 高亮搜索结果
    
    # 性能和行为
    wrap = true;                      # 启用换行
    scrolloff = 8;                    # 保留上下滚动的行数
    sidescrolloff = 8;
    mouse = "a";                      # 启用鼠标支持
    clipboard = "unnamedplus";        # 使用系统剪贴板
    
    # 显示选项
    showmode = false;                 # 隐藏模式指示
    cmdheight = 1;                    # 命令行高度
    updatetime = 100;                 # 更新间隔（毫秒）
    timeoutlen = 300;                 # 超时时间
    
    # 其他
    hidden = true;                    # 切换缓冲区时不需要保存
    splitbelow = true;                # 分割窗口在下方
    splitright = true;                # 分割窗口在右方
    termguicolors = true;             # 真彩色支持
  };
}
