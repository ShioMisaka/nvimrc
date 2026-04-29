# Auto Session（自动会话管理）

自动保存和恢复 Neovim 会话——退出时记录所有 buffer、窗口布局和光标位置，下次打开同一目录时自动还原，实现无缝的工作流衔接。

## 快捷键

所有 Auto Session 快捷键使用 `<Space>s` 前缀。

### 会话管理

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>ss` | normal | 搜索并切换到其他会话（通过 Telescope 或 vim.ui.select） |
| `<Space>sd` | normal | 删除当前目录的会话 |
| `<Space>st` | normal | 切换自动保存开关 |

## 常用命令

| 命令 | 说明 |
|------|------|
| `:AutoSession search` | 打开会话选择器 |
| `:AutoSession save` | 手动保存当前目录的会话 |
| `:AutoSession save <name>` | 保存为指定名称的会话 |
| `:AutoSession restore` | 恢复当前目录的会话 |
| `:AutoSession restore <name>` | 恢复指定名称的会话 |
| `:AutoSession delete` | 删除当前目录的会话 |
| `:AutoSession delete <name>` | 删除指定名称的会话 |
| `:AutoSession toggle` | 切换自动保存开关 |
| `:AutoSession disable` | 禁用自动保存 |
| `:AutoSession enable` | 启用自动保存 |
| `:AutoSession purgeOrphaned` | 清理工作目录已不存在的孤立会话 |

### 会话选择器内操作

通过 `<Space>ss` 打开会话选择器后：

| 按键 | 说明 |
|------|------|
| `<CR>` | 加载选中会话 |
| `<C-d>` | 删除选中会话 |
| `<C-s>` | 切换到上一个会话（适合在两个项目间快速切换） |
| `<C-y>` | 复制选中会话 |

## 配置说明

插件定义位于 `lua/plugins/auto-session.lua`，当前配置要点：

- **`suppressed_dirs`**：在 `~/` 和 `/` 目录下不自动创建会话，避免 accidental session
- **`auto_restore_last_session`**：关闭，只在当前目录有对应会话时才恢复
- **`close_filetypes_on_save`**：保存会话前自动关闭 neo-tree 和 toggleterm，避免恢复时出现多余窗口
- **`sessionoptions`**：在 `init` 阶段设置为完整值，确保会话包含 buffers、folds、terminal 等信息

### 基本配置

```lua
-- lua/plugins/auto-session.lua
return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>ss", "<cmd>AutoSession search<CR>", desc = "搜索会话" },
    { "<leader>sd", "<cmd>AutoSession delete<CR>", desc = "删除当前会话" },
    { "<leader>st", "<cmd>AutoSession toggle<CR>", desc = "切换自动保存" },
  },
  opts = {
    suppressed_dirs = { "~/", "/" },
    auto_restore_last_session = false,
    close_filetypes_on_save = { "neo-tree", "toggleterm" },
    session_lens = {
      load_on_setup = true,
    },
  },
  init = function()
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
}
```

### 过滤会话目录

使用 `suppressed_dirs` 排除不需要会话的目录，`allowed_dirs` 限制只在特定目录下创建会话：

```lua
opts = {
  -- 仅在指定目录下创建会话（与 suppressed_dirs 取交集）
  allowed_dirs = { "~/projects/*", "~/work" },
  -- 在以下目录下不创建会话
  suppressed_dirs = { "~/", "/tmp" },
}
```

### 按分支隔离会话

启用后同一目录的不同 Git 分支会各自拥有独立的会话：

```lua
opts = {
  git_use_branch_name = true,
  git_auto_restore_on_branch_change = true,
}
```

### 自动清理过期会话

设置 `purge_after_minutes` 后，启动时会自动删除超过指定时间未访问的会话：

```lua
opts = {
  purge_after_minutes = 14400, -- 10 天未访问的会话将被清理
}
```

## 特性

- 启动时自动恢复当前目录的会话，退出时自动保存，无需手动操作
- 通过 Telescope 集成会话选择器，支持模糊搜索、预览、删除、复制会话
- 自动关闭 neo-tree 和 toggleterm 后再保存，避免恢复时出现幽灵窗口
- 会话文件存储在 `~/.local/share/nvim/sessions/`，按目录名索引
- 支持按 Git 分支隔离会话，切换分支时自动恢复对应会话
- 支持在 Lualine 状态栏中显示当前会话名称
