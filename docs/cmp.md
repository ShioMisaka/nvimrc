# 自动补全（nvim-cmp + LuaSnip）

基于 LSP、Buffer、路径和代码片段的自动补全，在插入模式下弹出候选列表，加速编码效率。

## 快捷键

补全弹窗的所有快捷键均在 **insert** 模式下生效（`<Tab>` 同时支持 snippet 模式）。补全弹窗由 LSP 或输入自动触发，也可用 `<C-Space>` 手动唤出。

### 补全弹窗操作

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<C-Space>` | insert | 手动触发补全弹窗 |
| `<Tab>` | insert / snippet | 选择下一个补全项；弹窗未显示时回退默认行为 |
| `<CR>` | insert | 确认补全（弹窗有选中项时自动确认） |
| `<C-b>` | insert | 补全文档向上翻页 |
| `<C-f>` | insert | 补全文档向下翻页 |

## 常用命令

### nvim-cmp 命令

| 命令 | 说明 |
|------|------|
| `:CmpStatus` | 查看所有补全来源的注册状态（部分来源在 InsertEnter 后才会注册，显示 `unknown` 是正常的） |

### nvim-cmp Lua API

以下 API 可在配置或映射中通过 `require('cmp')` 调用：

| API | 说明 |
|-----|------|
| `cmp.complete()` | 手动触发补全 |
| `cmp.close()` | 关闭补全弹窗 |
| `cmp.abort()` | 关闭补全弹窗并恢复到补全开始前的行状态 |
| `cmp.confirm({ select = true })` | 确认当前选中项；`select = true` 时未手动选择也会确认第一项 |
| `cmp.select_next_item()` | 选择下一个补全项 |
| `cmp.select_prev_item()` | 选择上一个补全项 |
| `cmp.scroll_docs(delta)` | 滚动文档窗口，正数向下，负数向上 |
| `cmp.complete_common_string()` | 补全所有候选项的公共前缀（类似 shell 补全） |
| `cmp.visible()` | 返回补全弹窗是否可见（布尔值） |
| `cmp.setup({})` | 全局配置 |
| `cmp.setup.filetype(ft, {})` | 按文件类型配置 |
| `cmp.setup.buffer({})` | 按当前 buffer 配置 |
| `cmp.setup.cmdline(type, {})` | 按命令行类型配置（`/`、`:`） |

### LuaSnip 操作

LuaSnip 是本配置使用的代码片段引擎，展开 LSP 返回的 snippet。以下是其核心 API：

| API | 说明 |
|-----|------|
| `ls.expand()` | 在光标处展开 snippet（仅展开，不跳转） |
| `ls.jump(1)` | 跳转到 snippet 的下一个 tabstop |
| `ls.jump(-1)` | 跳转到 snippet 的上一个 tabstop |
| `ls.expand_or_jumpable()` | 判断光标处是否可以展开或跳转（返回布尔值） |
| `ls.choice_active()` | 判断当前是否在 choiceNode 中（返回布尔值） |
| `ls.change_choice(1)` | 切换到 choiceNode 中的下一个选项 |

> 在当前配置中，`<Tab>` 已绑定 cmp 的 `select_next_item`，同时映射模式包含 snippet（`{ "i", "s" }`），因此 snippet 的 tabstop 跳转通过 `<Tab>` 完成。如果需要独立的 snippet 跳转键，可参考下方"自定义 LuaSnip 快捷键"配置。

### 自定义 LuaSnip 快捷键

当前配置未单独映射 LuaSnip 的跳转键。如需添加独立的 snippet 操作快捷键，可在配置中加入以下映射：

```lua
local ls = require("luasnip")

-- Ctrl-L：展开或跳转到下一个 tabstop
vim.keymap.set({ "i", "s" }, "<C-L>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true, desc = "展开或跳转到下一个 snippet 节点" })

-- Ctrl-J：跳转到上一个 tabstop
vim.keymap.set({ "i", "s" }, "<C-J>", function()
  ls.jump(-1)
end, { silent = true, desc = "跳转到上一个 snippet 节点" })

-- Ctrl-E：切换 choiceNode 选项
vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true, desc = "切换 snippet 选项" })
```

## 配置说明

配置文件路径：`lua/plugins/cmp.lua`。

### 基础配置

以下是最小可用的补全配置，包含 LSP、LuaSnip、Buffer 和路径四个补全来源：

```lua
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end,
}
```

### 补全来源

| 来源 | 说明 |
|------|------|
| `nvim_lsp` | LSP 服务器提供的智能补全 |
| `luasnip` | 代码片段（Snippet）补全 |
| `buffer` | 当前 Buffer 中已有的文字 |
| `path` | 文件系统路径补全 |

### 关键配置项说明

- **`snippet.expand`**：使用 LuaSnip 展开 LSP 返回的代码片段，必须配置否则 snippet 类补全无法使用。
- **`mapping.confirm({ select = true })`**：`<CR>` 确认时，如果弹窗中有选中项会自动确认，无需手动选择。
- **`<Tab>` 映射模式 `{ "i", "s" }`**：在 insert 模式和 snippet 模式下均可使用 Tab 跳转补全项；弹窗未弹出时回退到默认 Tab 行为。

### 禁用预选行为

默认情况下 nvim-cmp 会遵循 LSP 的 `preselect` 规范自动预选第一项。如果不需要此行为：

```lua
cmp.setup({
  preselect = cmp.PreselectMode.None,
})
```

### 按文件类型定制补全来源

可以为特定文件类型配置不同的补全来源：

```lua
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" },
  }, {
    { name = "buffer" },
  }),
})
```

### 命令行补全

nvim-cmp 支持在 Neovim 命令行中使用补全：

```lua
-- 搜索命令（/ 和 ?）使用 buffer 补全
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- 冒号命令（:）使用 path 和 cmdline 补全
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
```

> 命令行补全需要额外安装 `hrsh7th/cmp-cmdline` 插件。

### 添加边框窗口样式

默认的补全弹窗没有边框，可通过以下配置添加带边框的样式：

```lua
cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})
```

## 特性

- 输入时自动弹出补全列表，无需手动触发
- `<CR>` 智能确认：有选中项时自动补全，否则插入换行
- `<Tab>` 回退机制：弹窗未显示时不干扰正常的 Tab 缩进行为
- 四个补全来源覆盖 LSP、代码片段、当前文件和文件路径
- 补全文档支持翻页浏览（`<C-b>` / `<C-f>`）
- 支持按文件类型、按 buffer、按命令行类型分别配置补全来源
- 支持命令行补全（`/`、`:`）和路径补全
