# Neovim Configuration

## Prerequisites

- Neovim >= 0.10
- A Nerd Font (e.g. [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads))

## Installation

```bash
git clone https://github.com/your-username/nvim-config.git ~/.config/nvim
```

首次启动 Neovim 时，[lazy.nvim](https://github.com/folke/lazy.nvim) 会自动安装并拉取所有插件依赖。

## Clipboard Support

WSL2 环境下 Neovim 需要额外的剪贴板工具才能与系统剪贴板通信。

```bash
# Arch Linux
sudo pacman -S wl-clipboard xclip

# Debian/Ubuntu
sudo apt install wl-clipboard xclip
```

验证：

```vim
:echo has('clipboard')
```

返回 `1` 即表示剪贴板支持正常。

---

## 快捷键总览

Leader 键为 `Space`。

### 通用

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `jk` / `kj` | insert / terminal | 退出编辑模式 |
| `Esc` | normal | 清除搜索高亮 |
| `q` | normal | 关闭当前 buffer（未保存时弹出确认） |
| `q` | visual | 取消选择 |
| `<Space>w` | normal | 保存文件 |
| `<Space>q` | normal | 退出 Neovim |
| `<C-h/j/k/l>` | normal | 在窗口间移动焦点 |
| `gh` | normal | 跳转到行首 |
| `gl` | normal | 跳转到行尾 |
| `Alt-o` | normal | 在 `.cpp` / `.h` 之间切换 |

---

## 插件详情

各插件的完整操作说明、快捷键和配置方法详见 `docs/` 目录。

| 插件 | 说明 | 文档 |
|------|------|------|
| [Neo-tree](docs/neo-tree.md) | 侧边栏文件浏览器，支持 Git 状态、诊断标记、文件监听 | 快捷键、窗口内操作、命令 |
| [Telescope](docs/telescope.md) | 模糊查找器，支持文件、文本、Buffer、Git 搜索，集成 fzf | 快捷键、窗口内操作、内置选择器速查 |
| [LSP](docs/lsp.md) | 代码补全、跳转定义、重命名、诊断（自动过滤 build/install 目录） | 快捷键、LSP 管理命令、诊断命令 |
| [nvim-cmp](docs/cmp.md) | 自动补全，基于 LSP、Buffer、路径和代码片段 | 快捷键、LuaSnip API、配置扩展 |
| [Mason](docs/mason.md) | LSP 服务器、DAP 调试器、Linter 等外部工具包管理 | 界面操作、安装/卸载命令 |
| [Treesitter](docs/treesitter.md) | 基于语法树的精确代码高亮 | 解析器管理命令、模块控制 |
| [ToggleTerm](docs/toggleterm.md) | 内嵌终端，支持浮动/水平/垂直布局，多终端实例 | 快捷键、终端管理命令、发送内容 |
| [UI](docs/ui.md) | TokyoNight 主题 + Bufferline 标签栏 + Lualine 状态栏 | Bufferline 命令、Lualine API |
| [Auto Session](docs/auto-session.md) | 自动保存/恢复会话，支持按目录和 Git 分支隔离 | 快捷键、会话管理命令、选择器操作 |
| [nvim-lastplace](docs/nvim-lastplace.md) | 智能光标位置记忆，重新打开文件时跳转到上次编辑处 | 配置过滤规则 |

### 已配置的语言服务器

| 服务器 | 语言 |
|--------|------|
| `clangd` | C / C++ |
| `lua_ls` | Lua |
| `pyright` | Python |
| `neocmake` | CMake |

---

## 其他配置

- 行号：绝对行号 + 相对行号
- 缩进：4 空格，Tab 转空格
- 搜索：默认忽略大小写，输入大写字母后区分大小写
- 新窗口：垂直分割在右侧，水平分割在下方
- 剪贴板：与系统共享（`unnamedplus`）
- 复制高亮：复制文本后短暂高亮显示
- OSC 52 回退：无系统剪贴板时通过终端转义序列复制
- 撤销历史：持久化（`undofile`）
- 滚动偏移：光标距上下边缘至少 8 行（`scrolloff`）
- 映射超时：300ms（`timeoutlen`）
