# 可选工具配置
# 这些工具用于增强功能，但不是必需的
# 如果需要图像渲染、PDF 预览等功能，可以取消注释相应的包

{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    # 图像处理工具（用于 Snacks.image）
    imagemagick  # 图像转换和处理
    ghostscript  # PDF 渲染
    
    # LaTeX 工具（用于数学表达式渲染）
    tectonic     # 现代 LaTeX 编译器
    # texlive.combined.scheme-medium
    
    # Mermaid 图表渲染
    nodePackages.mermaid-cli
    
    # SQLite（用于 Snacks.picker 的历史和频率功能）
    sqlite
  ];
}
