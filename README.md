# LazyVim NixOS Flake Module

完全使用 Nix 配置的 LazyVim 环境，包含 LSP、DAP 调试器、Treesitter 等完整功能。

## ✨ 特性

- 🚀 开箱即用的 LazyVim 配置
- 🔧 完整的 LSP 支持（Lua, Python, Bash, TypeScript, Markdown, Nix）
- 🐛 集成的调试器 (DAP)：C/C++ (GDB), Python, JavaScript/TypeScript
- 🌳 Treesitter 语法高亮和代码解析
- 🔍 模糊查找 (Telescope + FZF)
- 📦 所有工具由 Nix 管理，无需 Mason
- ⚡ 快速、可复现、声明式配置

## 📦 使用方法

### 作为 NixOS 模块使用

```nix
# /etc/nixos/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lazyvim-nix = {
      url = "github:gujial/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, lazyvim-nix, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        lazyvim-nix.nixosModules.lazyvim
      ];
    };
  };
}
```

### 作为开发环境使用

```bash
# 克隆仓库
git clone https://github.com/gujial/lazyvim-nix
cd lazyvim-nix

# 进入开发环境
nix develop

# 启动 nvim
nvim
```

## 🐛 调试功能

### C/C++ 调试

```bash
# 编译时添加调试符号
g++ -g -o program program.cpp

# 在 Neovim 中按 F5 启动调试
```

### Python 调试

需要安装 debugpy：
```bash
pip install debugpy
```

### 快捷键

| 快捷键 | 功能 |
|--------|------|
| `<F5>` | 开始/继续调试 |
| `<F10>` | 步过 (Step Over) |
| `<F11>` | 步入 (Step Into) |
| `<Shift-F11>` | 步出 (Step Out) |
| `<leader>db` | 切换断点 |
| `<leader>dB` | 设置条件断点 |
| `<leader>dc` | 清除所有断点 |
| `<leader>du` | 切换调试 UI |

## 📚 模块结构

```
modules/
├── default.nix        # 主配置整合
├── plugins.nix        # LazyVim 插件配置
├── lsp.nix           # LSP 服务器配置
├── dap.nix           # 调试器配置
├── treesitter.nix    # Treesitter 配置
├── ui.nix            # UI 配置
├── keybindings.nix   # 快捷键配置
├── options.nix       # Neovim 选项
└── optional-tools.nix # 可选工具（图像渲染等）
```

## 🔍 健康检查

查看系统状态：
```vim
:checkhealth
```

详细说明请查看 [HEALTH_CHECK.md](./HEALTH_CHECK.md)。

## 🛠️ 已安装的工具

### LSP 服务器
- lua-language-server (Lua)
- bash-language-server (Bash)
- marksman (Markdown)
- pyright (Python)
- ruff (Python linter)
- vtsls (TypeScript/JavaScript)
- nil (Nix)

### 调试器
- GDB (C/C++)
- LLDB (C/C++)
- vscode-js-debug (JavaScript/TypeScript)
- debugpy (Python)

### 工具
- ripgrep (快速搜索)
- fd (文件查找)
- fzf (模糊查找)
- lazygit (Git TUI)
- tree-sitter (语法解析)

## 🎨 自定义

编辑相应的模块文件以自定义配置：

- **添加 LSP 服务器**: 编辑 `modules/lsp.nix`
- **配置调试器**: 编辑 `modules/dap.nix`
- **修改快捷键**: 编辑 `modules/keybindings.nix`
- **添加插件**: 编辑 `modules/plugins.nix`

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT
```
