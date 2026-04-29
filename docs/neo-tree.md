# Neo-tree（文件浏览器）

侧边栏文件树，支持 Git 状态显示、诊断标记、文件跟随等功能，替代系统默认的 netrw 文件浏览器。

## 快捷键

通过 `<Space>e` 切换文件树显示/隐藏，`<Space>E` 定位并高亮当前文件。文件树内部使用 `j`/`k` 上下移动，`h`/`l` 操作文件夹。

### 打开与定位

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>e` | normal | 切换文件树显示/隐藏 |
| `<Space>E` | normal | 定位并高亮当前文件 |

### 文件树内导航

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `j` / `k` | normal | 上下移动光标 |
| `h` | normal | 收起文件夹（已自定义） |
| `l` | normal | 展开文件夹或打开文件（已自定义，原为 `focus_preview`） |
| `<CR>` | normal | 打开文件/文件夹 |
| `<Esc>` | normal | 关闭预览或浮动窗口 |

### 文件与目录操作

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `a` | normal | 新建文件/目录（支持花括号展开，如 `x{a,b,c}`） |
| `A` | normal | 新建目录 |
| `d` | normal | 删除文件/目录 |
| `r` | normal | 重命名文件/目录 |
| `b` | normal | 仅重命名文件名（不含扩展名） |
| `c` | normal | 复制到指定路径 |
| `m` | normal | 移动到指定路径 |
| `y` | normal | 复制到 Neo-tree 内部剪贴板 |
| `x` | normal | 剪切到 Neo-tree 内部剪贴板 |
| `p` | normal | 从剪贴板粘贴 |
| `<C-r>` | normal | 清空剪贴板 |
| `Y` | normal | 复制文件完整路径到系统剪贴板（已自定义） |

### 打开方式

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `S` | normal | 水平分割打开 |
| `s` | normal | 垂直分割打开 |
| `t` | normal | 在新标签页中打开 |
| `w` | normal | 使用窗口选择器打开（需 nvim-window-picker） |
| `P` | normal | 切换预览模式（浮动窗口） |

### 目录浏览与搜索

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<BS>` | normal | 返回上级目录 |
| `.` | normal | 将当前目录设为根目录 |
| `H` | normal | 切换隐藏文件显示 |
| `/` | normal | 模糊搜索文件 |
| `D` | normal | 模糊搜索目录 |
| `#` | normal | 按 fzy 算法模糊排序 |
| `f` | normal | 提交过滤条件 |
| `<C-x>` | normal | 清除过滤条件 |
| `C` | normal | 收起当前目录 |
| `z` | normal | 收起所有目录 |

### Git 与排序

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `[g` | normal | 跳转到上一个 Git 修改的文件 |
| `]g` | normal | 跳转到下一个 Git 修改的文件 |
| `o` | normal | 打开排序选项菜单 |

### 其他

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `q` | normal | 关闭 Neo-tree 窗口 |
| `R` | normal | 刷新文件树 |
| `?` | normal | 显示快捷键帮助 |
| `i` | normal | 显示文件详细信息（大小、类型、修改时间等） |
| `<` / `>` | normal | 切换到上一个/下一个数据源 |

## 配置说明

配置文件路径：`lua/plugins/neo-tree.lua`。

### 基础配置

```lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  init = function()
    vim.g.loaded_netrw = 1       -- 禁用 netrw
    vim.g.loaded_netrwPlugin = 1
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    window = {
      position = "left",
      width = 30,
    },
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
  },
}
```

### 窗口内自定义映射

`h`、`l`、`Y` 三个按键被自定义覆盖，`<Space>` 在文件树窗口内被禁用：

```lua
window = {
  mappings = {
    ["<space>"] = "none",
    ["h"] = "close_node",
    ["l"] = {
      function(state)
        local node = state.tree:get_node()
        if node.type == "directory" then
          require("neo-tree.sources.filesystem").toggle_directory(state, node)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_id())
          state.commands.open(state)
        end
      end,
      desc = "展开文件夹或打开文件",
    },
    ["Y"] = {
      function(state)
        local node = state.tree:get_node()
        vim.fn.setreg("+", node:get_id(), "c")
        vim.notify("已复制: " .. node:get_id())
      end,
      desc = "复制路径到系统剪贴板",
    },
  },
},
```

### 文件过滤

默认显示隐藏文件和 Git 忽略文件：

```lua
filesystem = {
  filtered_items = {
    visible = false,
    hide_dotfiles = false,
    hide_gitignored = false,
  },
},
```

## 常用命令

### `:Neotree` 命令

`:Neotree` 命令支持多种参数组合，所有参数均可按任意顺序使用：

| 命令示例 | 说明 |
|----------|------|
| `:Neotree` | 打开左侧文件树 |
| `:Neotree toggle` | 切换文件树显示/隐藏 |
| `:Neotree reveal` | 打开文件树并定位到当前文件 |
| `:Neotree right` | 在右侧打开文件树 |
| `:Neotree float` | 以浮动窗口打开 |
| `:Neotree position=current` | 在当前窗口内打开（类似 netrw） |
| `:Neotree buffers` | 切换到 Buffer 列表视图 |
| `:Neotree git_status` | 以浮动窗口显示 Git 状态 |
| `:Neotree dir=/path/to/dir` | 打开指定目录 |
| `:Neotree reveal_file=<path>` | 定位到指定文件 |

### 模糊搜索窗口内按键

在文件树中按 `/` 或 `D` 进入模糊搜索后，可使用以下按键：

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<C-n>` / `<Down>` | normal / insert | 向下移动 |
| `<C-p>` / `<Up>` | normal / insert | 向上移动 |
| `<Esc>` | normal / insert | 关闭搜索窗口 |
| `<S-CR>` | normal / insert | 关闭搜索窗口并保留过滤条件 |
| `<C-CR>` | normal / insert | 关闭搜索窗口并清除过滤条件 |

## 特性

- 禁用系统默认的 netrw 文件浏览器，完全由 Neo-tree 接管
- 文件跟随：切换文件时文件树自动定位到当前文件
- Git 状态标记和 LSP 诊断图标显示
- 基于 libuv 的文件监听，文件变化实时刷新
- 不隐藏点文件和 gitignore 文件
- 自定义 `h`/`l` 键实现类 IDE 的目录导航体验
- `Y` 一键复制完整路径到系统剪贴板
