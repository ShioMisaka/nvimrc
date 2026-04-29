# 快捷键速查表

Leader 键：`Space`

---

## 通用操作

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `jk` / `kj` | Insert / Terminal | 退出到 Normal 模式 |
| `Q` | Normal | 录制 / 停止宏（原 `q` 键功能） |
| `q` | Normal | 关闭当前 Buffer |
| `q` | Visual | 退出选择模式（等同 Esc） |
| `<Esc>` | Normal | 清除搜索高亮 |
| `<leader>q` | Normal | 退出 Neovim（有未保存文件时弹窗确认） |

## 光标移动

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gh` | Normal | 移动到行首 |
| `gl` | Normal | 移动到行尾 |

## 行操作

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `Alt+j` | Normal / Visual | 向下移动当前行 / 选中行 |
| `Alt+k` | Normal / Visual | 向上移动当前行 / 选中行 |

## 窗口

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `Ctrl+h/j/k/l` | Normal | 切换到 左/下/上/右 窗口 |
| `<leader>v` | Normal | 垂直拆分窗口 |
| `<leader>s` | Normal | 水平拆分窗口 |
| `<leader>x` | Normal | 关闭当前窗口 |

## Buffer

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `Alt+h` | Normal | 切换到上一个 Buffer |
| `Alt+l` | Normal | 切换到下一个 Buffer |
| `Alt+Shift+h` | Normal | 将当前 Buffer 左移 |
| `Alt+Shift+l` | Normal | 将当前 Buffer 右移 |
| `Alt+1~5` | Normal | 跳转到第 N 个 Buffer |
| `<leader>bc` | Normal | 选择并关闭 Buffer |
| `<leader>bo` | Normal | 关闭其他 Buffer |

## 文件浏览器 (Neo-tree)

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>e` | Normal | 切换文件浏览器 |
| `<leader>E` | Normal | 定位当前文件 |

Neo-tree 内部：

| 快捷键 | 说明 |
|--------|------|
| `h` | 折叠目录 |
| `l` | 展开目录 / 打开文件 |
| `Y` | 复制路径到系统剪贴板 |

## 查找 (Telescope)

| 快捷键 | 说明 |
|--------|------|
| `<leader>ff` | 查找文件（含隐藏文件） |
| `<leader>fw` | 全局文本搜索（含隐藏文件） |
| `<leader>fb` | 查找已打开的 Buffer |
| `<leader>fo` | 最近打开的文件 |
| `<leader>fh` | 查找帮助文档 |
| `<leader>fs` | 当前文件符号（需 LSP） |
| `<leader>fW` | 工作区符号（需 LSP） |
| `<leader>fc` | 查找命令 |
| `<leader>fk` | 查找快捷键 |
| `<leader>ft` | Telescope 内置选择器 |

Telescope 内部：

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `Ctrl+j` | Insert | 下一个选项 |
| `Ctrl+k` | Insert | 上一个选项 |
| `Ctrl+u` | Insert | 向上滚动预览（已禁用，用于删除字符） |
| `Esc` | Insert | 关闭 |
| `q` | Normal | 关闭 |

## Git (Telescope)

| 快捷键 | 说明 |
|--------|------|
| `<leader>gf` | Git 文件 |
| `<leader>gc` | Git 提交记录 |
| `<leader>gb` | Git 分支 |
| `<leader>gs` | Git 状态 |

## LSP

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gd` | Normal | 跳转到定义 |
| `gD` | Normal | 跳转到声明 |
| `gi` | Normal | 跳转到实现 |
| `gy` | Normal | 跳转到类型定义 |
| `gr` | Normal | 查找引用 |
| `K` | Normal | 悬浮提示 |
| `<leader>rn` | Normal | 重命名 |
| `<leader>ca` | Normal | 代码动作 |
| `<leader>de` | Normal | 错误详情（诊断弹窗） |
| `[d` | Normal | 上一个诊断 |
| `]d` | Normal | 下一个诊断 |
| `Alt+o` | Normal | 切换 .h / .cpp（clangd） |

> 所有 LSP 跳转自动过滤 build/、install/ 目录，并映射到对应的源码路径。

## 补全 (nvim-cmp)

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `Tab` | Insert | 选择下一项 / 展开代码片段 |
| `Shift+Tab` | Insert | 选择上一项 / 跳回代码片段 |
| `Enter` | Insert | 确认补全（自动选中第一项） |
| `Ctrl+Space` | Insert | 手动触发补全 |
| `Ctrl+b` | Insert | 文档向上滚动 |
| `Ctrl+f` | Insert | 文档向下滚动 |

## 格式化 (conform.nvim)

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>cf` | Normal / Visual | 格式化代码 |
| `<leader>w` | Normal | 格式化并保存 |

## 终端 (toggleterm)

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `Ctrl+\` | Normal | 切换终端 1（水平） |
| `<leader>tf` | Normal | 浮动终端 |
| `<leader>th` | Normal | 水平终端 |
| `<leader>tv` | Normal | 垂直终端 |

## 会话 (auto-session)

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>ss` | Normal | 搜索会话 |
| `<leader>sd` | Normal | 删除当前会话 |
| `<leader>st` | Normal | 切换自动保存 |

---

## Neovim 原生常用操作

### 模式切换

| 操作 | 说明 |
|------|------|
| `i` | 在光标前进入 Insert 模式 |
| `a` | 在光标后进入 Insert 模式 |
| `I` | 在行首进入 Insert 模式 |
| `A` | 在行尾进入 Insert 模式 |
| `o` | 在下方新建一行并进入 Insert 模式 |
| `O` | 在上方新建一行并进入 Insert 模式 |
| `v` | 进入 Visual（字符选择）模式 |
| `V` | 进入 Visual Line（行选择）模式 |
| `Ctrl+v` | 进入 Visual Block（块选择）模式 |

### 光标移动

| 操作 | 说明 |
|------|------|
| `h` `j` `k` `l` | 左 / 下 / 上 / 右 |
| `w` / `b` | 下一个 / 上一个 单词词首 |
| `e` | 当前或下一个单词词尾 |
| `0` | 行首（第一列） |
| `^` | 行首（第一个非空字符） |
| `$` | 行尾 |
| `gg` | 文件开头 |
| `G` | 文件末尾 |
| `Ctrl+o` | 跳回上一个位置（jumplist 回退） |
| `Ctrl+i` | 跳到下一个位置（jumplist 前进） |
| `{number}G` | 跳到第 N 行 |
| `:{number}` | 跳到第 N 行 |
| `%` | 跳到匹配的括号 |

### 搜索与替换

| 操作 | 说明 |
|------|------|
| `/pattern` | 向下搜索 |
| `?pattern` | 向上搜索 |
| `n` / `N` | 下一个 / 上一个 搜索结果 |
| `*` / `#` | 向下 / 向上 搜索光标下的单词 |
| `:s/old/new/g` | 当前行替换 |
| `:%s/old/new/g` | 全文替换 |
| `:%s/old/new/gc` | 全文替换（逐个确认） |

### 编辑

| 操作 | 说明 |
|------|------|
| `x` | 删除光标处字符 |
| `dd` | 删除（剪切）当前行 |
| `yy` | 复制当前行 |
| `p` / `P` | 在光标后 / 前 粘贴 |
| `u` | 撤销 |
| `Ctrl+r` | 重做 |
| `.` | 重复上一次操作 |
| `>>` / `<<` | 增加 / 减少 缩进 |
| `J` | 将下一行合并到当前行 |
| `cw` | 删除到单词尾并进入 Insert 模式 |
| `ci"` | 删除双引号内容并进入 Insert 模式 |
| `diw` | 删除光标下的单词 |
| `ct<char>` | 删除到指定字符并进入 Insert 模式 |

### 可视模式操作

| 操作 | 说明 |
|------|------|
| 选中文本后 `y` | 复制选中内容 |
| 选中文本后 `d` | 删除选中内容 |
| 选中文本后 `>` / `<` | 增加 / 减少 缩进 |
| 选中文本后 `:s/old/new/g` | 在选中范围内替换 |

### 文件与标签页

| 操作 | 说明 |
|------|------|
| `:w` | 保存 |
| `:q` | 退出 |
| `:e filename` | 打开文件 |
| `:bn` / `:bp` | 下一个 / 上一个 Buffer |
| `:ls` | 列出所有 Buffer |
| `:tabnew` | 新建标签页 |
| `gt` / `gT` | 下一个 / 上一个 标签页 |

### 宏

| 操作 | 说明 |
|------|------|
| `Q{letter}` | 开始录制宏到指定寄存器（已映射到 Q） |
| `Q` | 停止录制 |
| `@{letter}` | 回放宏 |
| `@@` | 回放上一次执行的宏 |

### 其他

| 操作 | 说明 |
|------|------|
| `Ctrl+d` / `Ctrl+u` | 向下 / 向上 翻半页 |
| `Ctrl+f` / `Ctrl+b` | 向下 / 向上 翻整页 |
| `zz` | 将当前行居中显示 |
| `zt` / `zb` | 将当前行置顶 / 置底 |
| `:sort` | 对选中行排序（Visual 模式） |
| `:!(command)` | 执行外部命令 |
| `gf` | 打开光标下的文件路径 |
