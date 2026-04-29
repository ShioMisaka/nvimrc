# Which-Key（按键提示）

按下前缀键后暂停时，弹出浮动窗口显示所有可用的按键组合及功能描述，帮助你发现和记忆快捷键。

## 快捷键

Which-Key 没有专属快捷键，它在任何已注册的前缀键上自动激活。按下 `<Space>`、`g`、`z`、`[` 等前缀键后等待片刻，提示窗口即会弹出。

## 常用命令

| 命令 | 说明 |
|------|------|
| `:WhichKey` | 手动触发 Which-Key 弹窗 |
| `:WhichKey <prefix>` | 显示指定前缀下的所有按键映射 |

## 配置说明

配置文件：`lua/plugins/which-key.lua`

### 按键分组

通过 `spec` 定义 leader 键的分组标签，按下 `<Space>` 时会显示这些分组：

```lua
opts = {
  spec = {
    { "<leader>b", group = "Buffer" },
    { "<leader>d", group = "诊断" },
    { "<leader>f", group = "查找" },
    { "<leader>g", group = "Git" },
    { "<leader>r", group = "重构" },
    { "<leader>s", group = "水平拆分" },
    { "<leader>v", group = "垂直拆分" },
    { "<leader>x", group = "窗口" },
  },
},
```

### 自定义按键描述

在定义 keymap 时通过 `desc` 字段提供描述，Which-Key 会自动读取并显示：

```lua
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "查找文件" })
```

## 特性

- 自动发现所有已注册的 keymaps，无需手动维护
- 支持嵌套分组（多级前缀键）
- 延迟加载（`VeryLazy`），不影响启动速度
- 与 telescope、bufferline、lsp 等插件的 `desc` 字段无缝配合
