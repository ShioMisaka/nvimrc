# UI（界面）

包含三个界面插件：TokyoNight 主题、Bufferline 顶部标签栏、Lualine 底部状态栏。

## 快捷键

Bufferline 快捷键使用 `Alt` 键前缀进行 Buffer 切换和跳转，`<Space>b` 前缀进行 Buffer 关闭操作。TokyoNight 和 Lualine 没有专属快捷键。

### Buffer 切换与跳转

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<A-j>` | normal | 下一个 buffer |
| `<A-k>` | normal | 上一个 buffer |
| `<A-1>` | normal | 跳转到第 1 个 buffer |
| `<A-2>` | normal | 跳转到第 2 个 buffer |
| `<A-3>` | normal | 跳转到第 3 个 buffer |
| `<A-4>` | normal | 跳转到第 4 个 buffer |
| `<A-5>` | normal | 跳转到第 5 个 buffer |

### Buffer 移动与关闭

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<A-S-j>` | normal | 向右移动 buffer |
| `<A-S-k>` | normal | 向左移动 buffer |
| `<Space>bc` | normal | 选择关闭 buffer |
| `<Space>bo` | normal | 关闭其他 buffer |

## 常用命令

### Bufferline 命令

Bufferline 提供了一系列 Ex 命令用于 Buffer 管理，可在命令行模式（输入 `:`）直接使用：

#### Buffer 导航

| 命令 | 说明 |
|------|------|
| `:BufferLineCycleNext` | 切换到下一个 buffer |
| `:BufferLineCyclePrev` | 切换到上一个 buffer |
| `:BufferLineGoToBuffer <n>` | 跳转到第 n 个 buffer |
| `:BufferLineMoveNext` | 将当前 buffer 向右移动一位 |
| `:BufferLineMovePrev` | 将当前 buffer 向左移动一位 |

#### Buffer 关闭

| 命令 | 说明 |
|------|------|
| `:BufferLineCloseLeft` | 关闭当前 buffer 左侧的所有 buffer |
| `:BufferLineCloseRight` | 关闭当前 buffer 右侧的所有 buffer |
| `:BufferLinePickClose` | 进入选择模式，通过字母标记选择要关闭的 buffer |
| `:BufferLineCloseOthers` | 关闭除当前 buffer 外的所有 buffer |
| `:BufferLineCloseGroup` | 关闭当前 buffer 所在分组的所有 buffer |
| `:BufferLineCloseUnpinned` | 关闭所有未固定的 buffer |

#### Buffer 排序

| 命令 | 说明 |
|------|------|
| `:BufferLineSortByExtension` | 按文件扩展名排序 |
| `:BufferLineSortByDirectory` | 按文件所在目录排序 |
| `:BufferLineSortByRelativeDirectory` | 按相对目录排序 |
| `:BufferLineSortByTabs` | 按标签页分组排序 |
| `:BufferLineSortByWindowNumber` | 按窗口编号排序 |

#### Buffer 选择与固定

| 命令 | 说明 |
|------|------|
| `:BufferLinePick` | 进入选择模式，通过字母标记跳转到对应 buffer |
| `:BufferLineTogglePin` | 固定/取消固定当前 buffer（固定后不会被意外关闭或排序调整） |

### Lualine 命令

Lualine 提供以下 Ex 命令用于运行时控制状态栏：

| 命令 | 说明 |
|------|------|
| `:LualineBuffersJump <n>` | 跳转到 buffers 组件中第 n 个 buffer，`$` 表示最后一个 |
| `:LualineBuffersJump! <n>` | 同上，但不存在时不报错 |
| `:LualineRenameTab <name>` | 为当前标签页命名（在 tabs 组件中显示自定义名称） |

#### 运行时隐藏/显示 Lualine

通过 Lua 函数可以在运行时控制 Lualine 的显示状态：

```lua
-- 隐藏 Lualine（可指定 statusline / tabline / winbar）
require('lualine').hide()

-- 重新显示 Lualine
require('lualine').hide({ unhide = true })

-- 强制刷新 Lualine
require('lualine').refresh()
```

#### 获取当前配置

```lua
require('lualine').get_config()
```

## 配置说明

配置文件路径：`lua/plugins/ui.lua`。

### TokyoNight 主题

启动时立即加载，确保在其他插件之前生效：

```lua
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme tokyonight]])
  end,
}
```

TokyoNight 提供四种风格变体，可在 `vim.cmd` 中切换：

```lua
vim.cmd([[colorscheme tokyonight]])    -- 深色（默认）
vim.cmd([[colorscheme tokyonight-night]])  -- 深色
vim.cmd([[colorscheme tokyonight-storm]])  -- 深色（更蓝）
vim.cmd([[colorscheme tokyonight-day]])    -- 浅色
vim.cmd([[colorscheme tokyonight-moon]])   -- 浅色（偏暖）
```

### Bufferline 标签栏

顶部标签栏，显示所有已打开的 Buffer，支持 LSP 诊断标记和图标：

```lua
{
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        mode = "buffers",
        style_preset = bufferline.style_preset.default,
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        sort_by = "insert_after_current",
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    })
  end,
}
```

#### 常用配置项说明

- `mode`：`"buffers"` 显示所有 buffer，`"tabs"` 显示标签页
- `separator_style`：可选 `"thin"`、`"thick"`、`"slant"`（斜角）、`"padded_slant"`、`"slope"`
- `diagnostics`：设为 `"nvim_lsp"` 在标签上显示 LSP 诊断数量
- `sort_by`：排序方式，如 `"insert_after_current"`（新 buffer 插入当前之后）、`"extension"`、`"directory"` 等
- `hover`：鼠标悬停时显示关闭按钮等额外控件
- `close_command`：关闭 buffer 时使用的命令，此处使用 `Bdelete!` 确保终端等特殊 buffer 也能关闭

### Lualine 状态栏

底部状态栏，显示模式、文件名、Git 分支等信息，使用 TokyoNight 主题：

```lua
{
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "tokyonight",
        globalstatus = true,
      },
    })
  end,
}
```

#### 自定义主题

Lualine 支持内置主题和自定义主题。内置主题列表可在 `:h lualine-themes` 中查看：

```lua
require('lualine').setup {
  options = {
    theme = 'tokyonight',  -- 或 'gruvbox', 'dracula', 'onedark' 等
  },
}
```

自定义主题颜色示例（基于已有主题修改）：

```lua
local custom_theme = require('lualine.themes.tokyonight')
custom_theme.normal.c.bg = '#1a1b26'  -- 修改 normal 模式下中间区域的背景色

require('lualine').setup {
  options = { theme = custom_theme },
}
```

#### 自定义组件

Lualine 的状态栏分为 A/B/C（左侧）和 X/Y/Z（右侧）六个区域，可自由配置组件：

```lua
require('lualine').setup {
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}
```

可用组件：`mode`、`branch`、`filename`、`filetype`、`encoding`、`fileformat`、`diff`、`diagnostics`、`progress`、`location`、`searchcount`、`buffers`、`tabs`、`windows`、`lsp_status` 等。

#### 添加扩展

Lualine 可以为特定文件类型加载专属状态栏样式：

```lua
require('lualine').setup {
  extensions = { 'neo-tree', 'toggleterm', 'fzf', 'quickfix' },
}
```

## 特性

- TokyoNight 主题优先加载（priority = 1000），确保插件颜色正确
- Bufferline 斜角分隔符风格，LSP 诊断直接在标签上显示错误/警告数量
- Buffer 关闭使用 `Bdelete!` 而非 `bdelete`，避免关闭终端等特殊 Buffer
- Buffer 按插入顺序排序，新打开的 Buffer 紧跟当前 Buffer 之后
- Bufferline 鼠标悬停时显示关闭按钮（200ms 延迟）
- Lualine 全局状态栏（`globalstatus = true`），多窗口时只显示一个状态栏
- Lualine 主题与 TokyoNight 自动统一
