# 插入模式 Ctrl+hjkl 光标移动 实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在插入模式下用 `<C-hjkl>` 移动光标，免去伸手够方向键。

**Architecture:** 在 `lua/config/keymaps.lua` 追加 4 行插入模式映射，把 `<C-hjkl>` 绑定到 Vim 原生插入模式移动键 `<Left>`/`<Right>`/`<Up>`/`<Down>`，列位置保持与边界处理交给 Vim 原生语义，无自定义逻辑。

**Tech Stack:** Neovim >= 0.10，纯 Lua keymap，无新增依赖。

**参考规格:** `docs/superpowers/specs/2026-07-12-insert-mode-ctrl-hjkl-design.md`

## Global Constraints

- 缩进：4 空格，`expandtab`（来自 `lua/config/options.lua`）。
- 注释：中文，说明"为什么"，与周围风格一致。
- commit message：中文，简短。
- 插入模式交互无法在 headless 下可靠测试，需手动验证（AGENTS.md 约定）。
- 不改动 `lazy-lock.json`。
- normal 模式的 `<C-hjkl>` 窗口焦点切换映射（`keymaps.lua:74-77`）保持不变。

---

## 文件结构

| 文件 | 操作 | 职责 |
|------|------|------|
| `lua/config/keymaps.lua` | 修改 | 在第 145 行（terminal 模式 jk 退出映射）之后追加 4 行插入模式 `<C-hjkl>` 映射 |

单文件、单次追加。无新增文件、无新依赖、无对其他文件的改动。

---

### Task 1: 追加插入模式 Ctrl+hjkl 光标移动映射

**Files:**
- Modify: `lua/config/keymaps.lua`（在第 145-146 行 `map("t", "kj", ...)` 之后追加）

**Interfaces:**
- Consumes: `map`（`keymaps.lua:1` 定义的 `local map = vim.keymap.set`）
- Produces: 4 个插入模式 keymap，行为为 Vim 原生 `<Left>`/`<Right>`/`<Down>`/`<Up>`

- [ ] **Step 1: 读取目标文件，定位插入点**

打开 `lua/config/keymaps.lua`，确认第 145-146 行是 terminal 模式的 jk/kj 退出映射：

```lua
map("t", "jk", "<C-\\><C-n>", { silent = true })
map("t", "kj", "<C-\\><C-n>", { silent = true })
```

新映射追加在它们之后，与其他插入模式映射（jk/kj 在第 143-144 行）聚在同一区域。

- [ ] **Step 2: 追加 4 行映射**

在第 146 行 `map("t", "kj", ...)` 之后追加：

```lua

-- 插入模式下用 Ctrl+hjkl 移动光标，避免手离开主键区够方向键
-- 覆盖了 <C-h>(Backspace) 和 <C-k>(digraph)，退格用物理 <BS>，digraph 不再可用
map("i", "<C-h>", "<Left>", { desc = "插入模式：左移一字符", silent = true })
map("i", "<C-l>", "<Right>", { desc = "插入模式：右移一字符", silent = true })
map("i", "<C-j>", "<Down>", { desc = "插入模式：下移一行", silent = true })
map("i", "<C-k>", "<Up>", { desc = "插入模式：上移一行", silent = true })
```

- [ ] **Step 3: 语法验证**

运行：

```bash
cd /home/shioarch/.config/nvim && nvim --headless "+qa!"
```

Expected: 无错误输出，退出码 0。`keymaps.lua` 依赖 nvim runtime（`vim.keymap.set`、`vim.api` 等），需用完整配置启动；`-u NONE` 下 `vim.keymap` 命名空间可能不可用，不可用 `-u NONE` 单独加载该文件。

- [ ] **Step 4: 手动验证清单**

无法 headless 测试插入模式交互，请在 Neovim 中手动验证以下场景（参考 AGENTS.md 约定）：

1. 打开任意文件，`i` 进入插入模式。
2. `<C-h>`：光标左移一字符；`<C-l>`：光标右移一字符。
3. `<C-j>`：光标下移一行；`<C-k>`：光标上移一行。
4. 跨短行移动（从长行 `<C-j>` 到短行）：光标停在短行行尾，不回退到第 0 列；再下移回长行时恢复原列。
5. 输入代码触发 nvim-cmp 补全菜单，按 `<C-j>`/`<C-k>`：光标移动而非选择补全项（补全项仍用 `<Tab>`/`<S-Tab>`）。
6. normal 模式下 `<C-hjkl>`：仍是窗口焦点切换，未受影响。
7. 退格：物理 `<BS>` 键在插入模式下仍可删除字符。

- [ ] **Step 5: 提交**

```bash
cd /home/shioarch/.config/nvim
git add lua/config/keymaps.lua
git commit -m "添加插入模式 Ctrl+hjkl 光标移动"
```

---

## Self-Review

**1. Spec coverage（规格覆盖）：**
- `<C-j>`/`<C-k>` 上下跨行保持列 → Task 1 Step 2 映射 + Step 4 验证项 3-4 ✓
- `<C-h>`/`<C-l>` 单字符左右 → Task 1 Step 2 映射 + Step 4 验证项 2 ✓
- 补全菜单弹出时始终移动光标 → Task 1 Step 4 验证项 5 ✓（cmp.lua 无需改动，已确认无冲突）
- normal 模式窗口切换不受影响 → Task 1 Step 4 验证项 6 + Global Constraints ✓
- 冲突处理（覆盖 `<C-h>` Backspace、`<C-k>` digraph）→ 注释说明 + Step 4 验证项 7 ✓
- terminal 模式不添加映射 → 规格已明确不加，计划中无 terminal 改动 ✓
- 不改动 cmp.lua / lazy-lock.json → Global Constraints 明确 ✓

**2. Placeholder scan：** 无 TBD/TODO，所有步骤含完整代码与命令。✓

**3. Type/命名一致性：** 复用现有 `map` 局部变量；映射键名 `<C-h>`/`<C-j>`/`<C-k>`/`<C-l>` 与规格一致。✓
