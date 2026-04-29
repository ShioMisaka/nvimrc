# ToggleTerm（终端）

在 Neovim 内嵌终端，支持浮动、水平、垂直等多种布局方向，可同时管理多个终端实例。

## 快捷键

通过 `<C-\>` 切换默认终端，`<Space>t` 前缀打开指定方向的终端。终端模式下使用 `jk` 或 `kj` 退出到 Normal 模式。

### 终端打开与切换

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<C-\>` | normal | 切换终端 1（水平方向，默认） |
| `<Space>tf` | normal | 打开浮动终端（终端 2） |
| `<Space>th` | normal | 打开水平终端（终端 3） |
| `<Space>tv` | normal | 打开垂直终端（终端 4，宽度 60） |

### 终端模式退出

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `jk` / `kj` | terminal | 退出到 Normal 模式 |

## 常用命令

### 终端管理

| 命令 | 说明 |
|------|------|
| `:ToggleTerm` | 切换终端显示/隐藏，可用数字前缀指定终端 ID（如 `:2ToggleTerm`） |
| `:ToggleTerm direction=float` | 以浮动方向打开终端 |
| `:ToggleTerm direction=horizontal` | 以水平方向打开终端 |
| `:ToggleTerm direction=vertical` | 以垂直方向打开终端 |
| `:ToggleTermToggleAll` | 打开所有已打开的终端，或关闭所有终端 |
| `:TermExec cmd="命令" dir=路径` | 在指定终端执行命令，如 `:2TermExec cmd="git status" dir=~/project` |
| `:TermNew` | 在下一个可用 ID 打开新终端 |
| `:TermSelect` | 通过 `vim.ui.select` 选择并打开终端 |
| `:ToggleTermSetName 名称` | 为终端设置显示名称 |

### 向终端发送内容

| 命令 | 说明 |
|------|------|
| `:ToggleTermSendCurrentLine` | 将当前光标所在行发送到终端 |
| `:ToggleTermSendVisualLines` | 将可视模式下选中的所有行发送到终端 |
| `:ToggleTermSendVisualSelection` | 将可视模式下选中的文本（含块选）发送到终端 |

以上命令均可附加终端 ID 参数，如 `:ToggleTermSendCurrentLine 2` 将内容发送到终端 2。省略 ID 时默认发送到第一个终端。

### TermExec 参数说明

| 参数 | 说明 |
|------|------|
| `cmd` | 要执行的命令（必须用引号包裹） |
| `dir` | 终端工作目录，支持 `:h expand` 的特殊关键字 |
| `size` | 终端尺寸 |
| `direction` | 终端方向 |
| `name` | 终端显示名称 |
| `go_back=0` | 执行后不返回原窗口（默认会返回） |
| `open=0` | 不打开终端窗口，仅发送命令 |

## 配置说明

配置文件：`lua/plugins/toggleterm.lua`

### 基础配置

- `size`：水平/垂直终端的尺寸（行数或列数），默认 15
- `direction`：默认打开方向，可选 `horizontal`、`vertical`、`float`、`tab`
- `hide_numbers`：隐藏终端行号
- `shade_terminals`：启用终端背景阴影，视觉区分终端与编辑区

```lua
{
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermExec" },
  opts = {
    size = 15,
    hide_numbers = true,
    shade_terminals = true,
    direction = "horizontal",
  },
}
```

### 浮动终端样式

通过 `float_opts` 自定义浮动终端的外观：

```lua
opts = {
  float_opts = {
    border = "rounded",  -- 边框样式：single / double / shadow / curved / rounded
    winblend = 0,        -- 窗口透明度（0 = 不透明）
  },
}
```

### 自定义终端快捷键

当前配置通过 `keys` 字段注册了四个终端快捷键，分别对应终端 1-4：

```lua
keys = {
  { "<C-\\>", "<cmd>1 ToggleTerm<cr>", desc = "切换终端1 (水平)" },
  { "<leader>tf", "<cmd>2 ToggleTerm direction=float<cr>", desc = "浮动终端" },
  { "<leader>th", "<cmd>3 ToggleTerm direction=horizontal<cr>", desc = "水平终端" },
  { "<leader>tv", "<cmd>4 ToggleTerm direction=vertical size=60<cr>", desc = "垂直终端" },
},
```

### 向终端发送内容（高级用法）

可通过 Lua API 将代码发送到终端，适用于 REPL 等场景：

```lua
-- 发送当前行到终端
vim.keymap.set("n", "<Space>sl", function()
  require("toggleterm").send_lines_to_terminal("single_line", true, { args = vim.v.count })
end, { desc = "发送当前行到终端" })

-- 发送可视选区到终端
vim.keymap.set("v", "<Space>sv", function()
  require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count })
end, { desc = "发送选中文本到终端" })
```

## 特性

- 支持浮动、水平、垂直、Tab 四种终端布局
- 可同时管理多个独立终端实例（通过数字 ID 区分）
- 终端背景阴影效果，视觉区分终端与编辑区
- 支持向终端发送行、选区内容，便于 REPL 交互
- 懒加载，仅在调用 `ToggleTerm`、`ToggleTermToggleAll`、`TermExec` 命令时加载插件
