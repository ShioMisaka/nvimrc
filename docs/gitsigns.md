# Gitsigns（Git 状态标记）

在编辑区左侧 sign column 中显示 Git 修改状态（新增、修改、删除），并提供 hunk 级别的暂存、重置、预览等操作。

## 快捷键

Hunk 操作使用 `<Space>h` 前缀，`]h` / `[h` 用于跳转，`ih` 用于文本对象选择。

### Hunk 导航

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `]h` | normal | 跳转到下一个 hunk |
| `[h` | normal | 跳转到上一个 hunk |

### Hunk 操作

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>hs` | normal | 暂存当前 hunk |
| `<Space>hr` | normal | 重置当前 hunk |
| `<Space>hs` | visual | 暂存选中的 hunk |
| `<Space>hr` | visual | 重置选中的 hunk |
| `<Space>hS` | normal | 暂存整个缓冲区 |
| `<Space>hR` | normal | 重置整个缓冲区 |
| `<Space>hp` | normal | 预览 hunk（浮动窗口） |
| `<Space>hb` | normal | 查看当前行的 blame 信息 |
| `<Space>hd` | normal | 打开 diff 视图 |

### 切换显示

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>tb` | normal | 切换行末 blame 显示 |
| `<Space>tw` | normal | 切换词级 diff 高亮 |

### 文本对象

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `ih` | operator-pending / visual | 选择当前 hunk |

## 常用命令

| 命令 | 说明 |
|------|------|
| `:Gitsigns` | 查看所有可用命令 |
| `:Gitsigns toggle_signs` | 切换 sign column 显示 |
| `:Gitsigns toggle_current_line_blame` | 切换行末 blame |
| `:Gitsigns toggle_word_diff` | 切换词级 diff |
| `:Gitsigns toggle_linehl` | 切换整行高亮 |
| `:Gitsigns toggle_numhl` | 切换行号高亮 |
| `:Gitsigns refresh` | 刷新所有缓冲区的 gitsigns 状态 |
| `:Gitsigns diffthis` | 打开与索引的 diff |
| `:Gitsigns blame` | 打开 blame 视图 |

## 配置说明

配置文件：`lua/plugins/gitsigns.lua`

### Sign 样式

sign column 中显示的符号，通过颜色区分状态（绿=新增，蓝=修改，红=删除）：

```lua
signs = {
  add          = { text = "▎" },
  change       = { text = "▎" },
  delete       = { text = "_" },
  topdelete    = { text = "‾" },
  changedelete = { text = "▎" },
  untracked    = { text = "▎" },
},
```

### 行末 Blame

默认关闭，可通过 `<Space>tb` 或命令开启。开启后会在每行末尾显示最近提交信息：

```lua
current_line_blame = false,
current_line_blame_opts = {
  virt_text_pos = 'eol',
  delay = 1000,
},
```

## 特性

- 在 sign column 实时显示 Git 修改状态（新增/修改/删除/未跟踪）
- 支持暂存区和未暂存区的双重标记（`signs_staged_enable = true`）
- Hunk 级别操作：暂存、重置、预览
- 行末 blame 显示（可切换）
- 词级 diff 高亮（可切换）
- Hunk 文本对象 `ih`，支持操作和选择
- 自动监听 `.git` 目录变化，实时更新
