# Markdown 工具集（渲染预览、编辑辅助、表格编辑）

整合三个插件，提供终端内 Markdown 渲染预览、链接跳转与编辑辅助、以及表格编辑功能。所有功能仅在 Markdown 文件中自动启用。

## 快捷键

Markdown 相关快捷键使用 `<Space>m` 前缀。`gx` 为 markdown.nvim 提供的 buffer-local 快捷键，仅在 Markdown 文件中生效。

### 预览与渲染

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>mp` | normal | 切换终端内 Markdown 渲染预览 |

### 链接与导航（markdown.nvim 默认键位）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gx` | normal | 打开光标下的链接 |
| `]]` | normal | 跳转到下一个标题 |
| `[[` | normal | 跳转到上一个标题 |
| `]c` | normal | 跳转到当前标题 |
| `]p` | normal | 跳转到父级标题 |
| `gl{motion}` | normal | 添加链接（如 `gliw` 给当前单词加链接） |
| `gl` | visual | 为选中内容添加链接 |

### 行内样式操作（markdown.nvim 默认键位）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gs{motion}{style}` | normal | 切换行内样式（`i`=斜体, `b`=粗体, `s`=删除线, `c`=代码） |
| `gss{style}` | normal | 当前行切换样式 |
| `gs{style}` | visual | 为选中内容切换样式 |
| `ds{style}` | normal | 删除光标处的样式 |
| `cs{from}{to}` | normal | 更改样式（如 `csbi` 将粗体改为斜体） |

### 表格编辑

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>mt` | normal | 切换表格编辑模式 |

## 常用命令

### render-markdown.nvim

| 命令 | 说明 |
|------|------|
| `:RenderMarkdown toggle` | 切换渲染开关 |
| `:RenderMarkdown enable` | 启用渲染 |
| `:RenderMarkdown disable` | 禁用渲染 |

### markdown.nvim

| 命令 | 说明 |
|------|------|
| `:MDInsertToc [max_level]` | 在光标处插入目录 |
| `:MDToc` | 在 location list 中显示目录 |
| `:MDListItemBelow` | 在下方插入列表项 |
| `:MDListItemAbove` | 在上方插入列表项 |
| `:MDTaskToggle` | 切换任务列表状态（`[x]` / `[ ]`） |
| `:MDResetListNumbering` | 重置有序列表编号 |

### vim-table-mode

| 命令 | 说明 |
|------|------|
| `:TableModeToggle` | 切换表格编辑模式 |
| `:TableModeEnable` | 启用表格模式 |
| `:TableModeDisable` | 禁用表格模式 |
| `:Tableize` | 将选中的 CSV 文本转为表格 |
| `:TableModeRealign` | 重新对齐表格 |

### 表格模式内操作

启用表格模式后，输入 `|` 分隔列，插件会自动格式化对齐：

```
| 姓名 | 地址 | 电话 |
|------|------|------|
| 张三 | 北京 | 1234 |
```

在插入模式中行首输入 `||` 可快速创建分隔线。

表格内的导航和操作：

| 按键 | 说明 |
|------|------|
| `[|` | 跳到左边单元格 |
| `]|` | 跳到右边单元格 |
| `{|` | 跳到上方单元格 |
| `}|` | 跳到下方单元格 |
| `i|` | 选中单元格内部（text object） |
| `a|` | 选中单元格（含右侧分隔符） |

## 配置说明

配置文件：`lua/plugins/markdown.lua`

三个插件均使用 `ft = "markdown"` 懒加载，仅在打开 Markdown 文件时才加载。

### 渲染预览配置

```lua
{
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  opts = {}, -- 使用默认配置即可获得良好效果
}
```

### 表格分隔符

已设置 `vim.g.table_mode_corner = "|"` 使用 Markdown 兼容的分隔符，生成的表格可直接用于 Markdown 文档。

## 特性

- 终端内实时渲染 Markdown：标题、代码块、列表、引用、表格等均有视觉增强
- 链接跳转：`gx` 支持打开 URL、文件路径和 Markdown 内部标题链接
- 行内样式操作：类似 vim-surround 的方式切换粗体、斜体、删除线、代码
- 目录生成：自动从文档标题生成目录列表
- 任务列表：快速切换 `[x]` / `[ ]` 状态
- 表格自动格式化：输入时自动对齐列宽，支持公式计算
