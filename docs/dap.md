# DAP（调试适配协议）

通过 DAP 协议提供断点调试能力，支持 Python（debugpy）。调试会话自动打开 DAP UI 面板，退出时自动关闭。

## 快捷键

DAP 快捷键使用 `<F>` 功能键控制调试流程，`<Space>d` 前缀管理断点和调试会话。

### 调试流程

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<F5>` | normal | 开始 / 继续调试 |
| `<F10>` | normal | 单步跳过（执行当前行，不进入函数） |
| `<F11>` | normal | 单步进入（进入函数内部） |
| `<F12>` | normal | 单步跳出（执行到当前函数返回） |

### 断点管理

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>db` | normal | 切换断点 |
| `<Space>dB` | normal | 设置条件断点（输入条件表达式） |

### 会话控制

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>dr` | normal | 重新运行上次调试配置 |
| `<Space>ds` | normal | 终止调试并关闭 UI |
| `<Space>du` | normal | 手动开关 DAP UI 面板 |

## 常用命令

| 命令 | 说明 |
|------|------|
| `:lua require("dap").continue()` | 开始或继续调试 |
| `:lua require("dap").toggle_breakpoint()` | 切换断点 |
| `:lua require("dap").list_breakpoints()` | 列出所有断点 |
| `:lua require("dap").repl.open()` | 打开 REPL 窗口 |
| `:lua require("dapui").toggle()` | 切换 DAP UI 面板 |

## 配置说明

配置文件路径：`lua/plugins/dap.lua`。

### DAP UI 自动开关

调试会话启动时自动打开 UI，终止或退出时自动关闭：

```lua
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
```

### Python 调试适配器

使用 Mason 安装的 debugpy 作为 Python 调试后端：

```lua
local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
require("dap-python").setup(debugpy)
```

首次使用前需安装 debugpy：

```vim
:MasonInstall debugpy
```

## 特性

- 支持 Python 断点调试（debugpy 适配器）
- DAP UI 面板自动开关（作用域、断点、调用栈、变量监听）
- 条件断点支持（`<Space>dB`）
- 与 neotest 集成，可直接调试单个测试用例（`<Space>td`）
