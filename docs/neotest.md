# neotest（测试运行器）

在 Neovim 内直接运行和查看测试结果，支持 pytest 框架。提供测试概览侧栏、输出面板和测试监听（文件保存时自动重跑）。

## 快捷键

所有测试快捷键使用 `<Space>t` 前缀。`]t` / `[t` 用于在失败测试之间跳转。

### 运行测试

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>tt` | normal | 运行离光标最近的测试 |
| `<Space>tF` | normal | 运行当前文件的所有测试 |
| `<Space>tl` | normal | 重新运行上次执行的测试 |
| `<Space>td` | normal | 调试最近的测试（需要 DAP） |
| `<Space>ts` | normal | 停止正在运行的测试 |

### 查看结果

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>to` | normal | 打开测试输出浮窗 |
| `<Space>tO` | normal | 切换测试输出面板（底部持久化窗口） |
| `<Space>tu` | normal | 切换测试概览侧栏（显示测试树和状态） |

### 监听与导航

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>tw` | normal | 切换测试监听（保存文件时自动重跑） |
| `]t` | normal | 跳转到下一个失败测试 |
| `[t` | normal | 跳转到上一个失败测试 |

## 常用命令

| 命令 | 说明 |
|------|------|
| `:lua require("neotest").run.run()` | 运行最近测试 |
| `:lua require("neotest").run.run(vim.fn.expand("%"))` | 运行当前文件测试 |
| `:lua require("neotest").summary.toggle()` | 切换概览侧栏 |
| `:lua require("neotest").output_panel.toggle()` | 切换输出面板 |

### 概览侧栏内操作

| 按键 | 说明 |
|------|------|
| `j` / `k` | 上下移动 |
| `<CR>` | 展开/折叠测试节点 |
| `o` | 跳转到测试源码 |
| `s` | 运行光标下的测试 |
| `S` | 运行并调试（DAP） |
| `a` | 运行所有测试 |
| `x` | 展开/折叠所有节点 |
| `q` | 关闭侧栏 |

## 配置说明

配置文件路径：`lua/plugins/neotest.lua`。

### Python 测试适配器

使用 neotest-python 适配器，默认使用 pytest 运行器：

```lua
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
  },
})
```

`justMyCode = false` 允许调试时进入第三方库代码。

## 特性

- 支持 pytest 和 unittest 框架
- 测试概览侧栏显示测试树和通过/失败状态
- 文件保存时自动重跑测试（监听模式）
- 与 DAP 集成，支持直接调试测试用例
- 自动检测项目虚拟环境（.venv、venv、poetry、pipenv）
