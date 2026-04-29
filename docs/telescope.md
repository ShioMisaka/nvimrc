# Telescope（模糊搜索）

强大的模糊查找器，支持文件、文本、Buffer、Git 等多种搜索源，集成了 fzf 排序算法。

## 快捷键

所有 Telescope 搜索快捷键使用 `<Space>f` 前缀，Git 相关搜索使用 `<Space>g` 前缀。搜索窗口内使用 `<C-j>` / `<C-k>` 上下移动，`q` 或 `Esc` 关闭窗口。

### 文件与文本搜索

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>ff` | normal | 查找文件（含隐藏文件） |
| `<Space>fw` | normal | 全局搜索文本（live grep，含隐藏文件） |
| `<Space>fb` | normal | 查找已打开的 Buffer |
| `<Space>fo` | normal | 查找最近打开的文件 |
| `<Space>fh` | normal | 查找帮助文档 |

### 符号与命令

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>fs` | normal | 当前文件的符号（函数、变量等） |
| `<Space>fW` | normal | 工作区符号 |
| `<Space>fc` | normal | 查找 Neovim 命令 |
| `<Space>fk` | normal | 查找快捷键 |
| `<Space>ft` | normal | Telescope 内置选择器列表 |

### Git

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Space>gf` | normal | Git 跟踪的文件 |
| `<Space>gc` | normal | Git 提交记录 |
| `<Space>gb` | normal | Git 分支 |
| `<Space>gs` | normal | Git 状态（已修改/暂存等） |

### 搜索窗口内导航

以下为本配置自定义的映射（覆盖了 Telescope 的部分默认值）：

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<C-k>` | insert | 上一条结果 |
| `<C-j>` | insert | 下一条结果 |
| `<Esc>` | insert | 关闭搜索窗口 |
| `q` | normal | 关闭搜索窗口 |

## 常用命令

### 打开搜索窗口

所有内置选择器均可通过命令行调用，支持 Tab 补全：

```vim
:Telescope find_files
:Telescope live_grep
:Telescope buffers
:Telescope <Tab>   " 列出所有可用选择器
```

也可以在命令中直接设置选项：

```vim
:Telescope find_files prompt_prefix=>
:Telescope live_grep search_dirs=src/
```

### 搜索窗口内操作

以下为 Telescope 原生默认映射，在本配置中未被覆盖的操作均可直接使用：

#### 结果选择与打开

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<C-n>` / `<Down>` | insert | 下一个结果 |
| `<C-p>` / `<Up>` | insert | 上一个结果 |
| `j` / `k` | normal | 下一个 / 上一个结果 |
| `H` / `M` / `L` | normal | 跳转到顶部 / 中间 / 底部结果 |
| `gg` / `G` | normal | 跳转到第一个 / 最后一个结果 |
| `<CR>` | - | 确认选择 |
| `<C-x>` | - | 在水平分割窗口中打开 |
| `<C-v>` | - | 在垂直分割窗口中打开 |
| `<C-t>` | - | 在新标签页中打开 |

#### 多选与 Quickfix

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Tab>` | - | 切换当前项选中状态，并跳到下一项 |
| `<S-Tab>` | - | 切换当前项选中状态，并跳到上一项 |
| `<C-q>` | - | 将所有未过滤的结果发送到 quickfix 列表 |
| `<Alt-q>` | - | 将所有已选中的结果发送到 quickfix 列表 |

#### 预览窗口滚动

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<C-u>` | insert | 预览窗口向上翻页 |
| `<C-d>` | insert | 预览窗口向下翻页 |
| `<C-f>` | insert | 预览窗口向左滚动 |
| `<C-k>` | insert | 预览窗口向右滚动（本配置已覆盖为移动选择） |
| `<Alt-f>` | insert | 结果列表向左滚动 |
| `<Alt-k>` | insert | 结果列表向右滚动 |

> **注意**：本配置将 insert 模式的 `<C-u>` 和 `<C-d>` 禁用，`<C-k>` 覆盖为 `move_selection_previous`。如需预览窗口翻页功能，可使用 normal 模式下的 `j` / `k` 导航后再操作，或修改配置恢复默认映射。

#### 关闭与帮助

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<C-c>` | insert | 关闭搜索窗口 |
| `<Esc>` | normal | 关闭搜索窗口（本配置中 insert 模式也已映射为关闭） |
| `<C-/>` | insert | 显示当前选择器可用映射 |
| `?` | normal | 显示当前选择器可用映射 |

#### 提示词插入

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<C-r><C-w>` | insert | 将光标所在单词插入到搜索提示中 |
| `<C-r><C-a>` | insert | 将光标所在 WORD（含符号）插入到搜索提示中 |
| `<C-r><C-f>` | insert | 将光标所在文件名插入到搜索提示中 |
| `<C-r><C-l>` | insert | 将光标所在行插入到搜索提示中 |

### 内置选择器速查

#### 文件类

| 选择器 | 说明 |
|--------|------|
| `find_files` | 列出工作目录中的文件 |
| `git_files` | 列出 Git 跟踪的文件 |
| `grep_string` | 搜索光标下的单词（全局） |
| `live_grep` | 实时全局文本搜索（需要 ripgrep） |

#### Vim 类

| 选择器 | 说明 |
|--------|------|
| `buffers` | 列出已打开的 Buffer |
| `oldfiles` | 列出最近打开的文件 |
| `commands` | 列出可用命令 |
| `keymaps` | 列出快捷键映射 |
| `help_tags` | 列出帮助标签 |
| `man_pages` | 列出 man 手册页 |
| `marks` | 列出 Vim 标记 |
| `colorscheme` | 列出可用配色方案 |
| `quickfix` | 列出 quickfix 列表项 |
| `loclist` | 列出当前窗口的 location 列表 |
| `jumplist` | 列出跳转列表 |
| `vim_options` | 列出 Vim 选项 |
| `registers` | 列出寄存器内容 |
| `command_history` | 列出命令历史 |
| `search_history` | 列出搜索历史 |
| `autocommands` | 列出自动命令 |
| `spell_suggest` | 列出拼写建议 |
| `filetypes` | 列出所有可用文件类型 |
| `highlights` | 列出所有高亮组 |
| `current_buffer_fuzzy_find` | 在当前 Buffer 内模糊搜索 |
| `current_buffer_tags` | 列出当前 Buffer 的标签 |
| `resume` | 恢复上一次搜索 |
| `pickers` | 列出历史搜索记录 |

#### LSP 类

| 选择器 | 说明 |
|--------|------|
| `lsp_references` | 列出引用 |
| `lsp_definitions` | 跳转到定义 |
| `lsp_type_definitions` | 跳转到类型定义 |
| `lsp_implementations` | 跳转到实现 |
| `lsp_incoming_calls` | 列出调用者 |
| `lsp_outgoing_calls` | 列出被调用者 |
| `lsp_document_symbols` | 当前文件的符号 |
| `lsp_workspace_symbols` | 工作区符号 |
| `lsp_dynamic_workspace_symbols` | 动态工作区符号 |
| `diagnostics` | 列出诊断信息 |

#### Git 类

| 选择器 | 说明 |
|--------|------|
| `git_commits` | 列出提交记录 |
| `git_bcommits` | 列出当前 Buffer 的提交记录 |
| `git_branches` | 列出分支 |
| `git_status` | 列出 Git 状态 |
| `git_stash` | 列出 stash 记录 |

## 配置说明

配置文件位于 `lua/plugins/telescope.lua`。

### 依赖

Telescope 需要以下插件配合工作：

```lua
dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope-fzf-native.nvim",   -- fzf 排序算法（需 make 编译）
  "nvim-telescope/telescope-ui-select.nvim",     -- 替代 vim.ui.select 弹窗
  "nvim-tree/nvim-web-devicons",                 -- 文件图标
},
```

### 搜索窗口映射

禁用默认的 `<C-u>` / `<C-d>` 翻页，改为 `<C-j>` / `<C-k>` 上下选择：

```lua
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<Esc>"] = actions.close,
      },
      n = {
        ["q"] = actions.close,
      },
    },
  },
})
```

### 文件忽略

默认忽略 `node_modules`、`.git/`、`.o`、`.class` 等文件：

```lua
require("telescope").setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/", "%.o$", "%.class$" },
  },
})
```

### 显示隐藏文件

`find_files` 和 `live_grep` 均配置为搜索隐藏文件：

```lua
require("telescope").setup({
  pickers = {
    find_files = { hidden = true },
    live_grep = {
      additional_args = function()
        return { "--hidden" }
      end,
    },
  },
})
```

### fzf 扩展

启用 fzf 模糊排序，使用 `smart_case` 模式（输入小写忽略大小写，输入大写区分大小写）：

```lua
require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})
pcall(require("telescope").load_extension, "fzf")
```

### 添加自定义快捷键

通过 `require("telescope.builtin")` 绑定新的快捷键：

```lua
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Space>ff", builtin.find_files, { desc = "查找文件" })
vim.keymap.set("n", "<Space>fw", builtin.live_grep, { desc = "全局搜索文本" })
```

## 特性

- 集成 fzf 排序算法，搜索速度更快、结果更精准
- 自动忽略 `node_modules`、`.git/`、`.o`、`.class` 等文件
- 文件搜索和文本搜索均包含隐藏文件
- 集成 `telescope-ui-select`，`vim.ui.select` 弹窗自动使用 Telescope 界面
- 支持预览窗口实时预览文件内容
- 支持多选并将结果发送到 quickfix 列表
