# Conform（代码格式化）

统一的代码格式化插件，支持保存时自动格式化、手动格式化和范围格式化。

## 快捷键

格式化快捷键使用 `<Space>cf`，同时支持 normal 和 visual 模式。`<Space>w` 保存时会先格式化再写入。

### 格式化操作

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>w` | normal | 格式化并保存 |
| `<Space>cf` | normal / visual | 仅格式化不保存（visual 模式下仅格式化选中区域） |
| `gq` | normal | 使用 `formatexpr` 格式化（Vim 原生操作） |

## 常用命令

### 内置命令

| 命令 | 说明 |
|------|------|
| `:ConformInfo` | 查看当前 buffer 配置的 formatter 及其状态 |

### 手动缩进（Neovim 内置）

无需任何插件即可使用的缩进操作：

| 操作 | 说明 |
|------|------|
| `>>` / `<<` | 缩进 / 反缩进当前行 |
| `V` 选中 → `>` / `<` | 缩进 / 反缩进选中行，`.` 重复 |
| `V` 选中 → `=` | 按文件类型规则重缩进选中行 |
| `gg=G` | 重缩进整个文件 |
| `=i{` / `=i(` | 重缩进当前代码块 |

## 配置说明

配置文件：`lua/plugins/conform.lua`

### 格式化工具映射

为每种文件类型配置外部格式化工具，按列表顺序依次执行：

```lua
formatters_by_ft = {
  lua = { "stylua" },
  python = { "isort", "black" },
  c = { "clang-format" },
  cpp = { "clang-format" },
  cmake = { "cmake_format" },
}
```

未配置外部工具的文件类型会自动回退到 LSP 格式化（`lsp_format = "fallback"`）。

### 格式化并保存

`<Space>w` 会先调用 conform 格式化当前 buffer，再执行 `:w` 保存。直接使用 `:w` 不会触发格式化。

```lua
-- lua/config/keymaps.lua
map("n", "<leader>w", function()
  require("conform").format({ async = false, lsp_fallback = true })
  vim.cmd("w")
end, { desc = "格式化并保存" })
```

### 系统依赖

需安装以下格式化工具（已通过 pacman 安装）：

| 工具 | 语言 | 安装命令 |
|------|------|----------|
| `stylua` | Lua | `pacman -S stylua` |
| `black` | Python | `pacman -S python-black` |
| `isort` | Python | `pacman -S python-isort` |
| `clang-format` | C/C++ | `pacman -S clang` |
| `cmake-format` | CMake | `pacman -S cmake-format` |

## 特性

- `<Space>w` 保存时自动格式化，直接 `:w` 不触发
- 未配置外部 formatter 时自动回退到 LSP
- 支持 visual 模式范围格式化
- 异步格式化，不阻塞 UI
- 使用 `formatexpr` 接管 `gq` 等原生格式化操作
