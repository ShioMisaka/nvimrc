# Treesitter（语法树高亮）

基于语法树（AST）的代码高亮引擎，比传统正则匹配更精确，能正确处理嵌套结构、字符串插值等复杂语法场景。

## 快捷键

Treesitter 当前未绑定自定义快捷键。高亮功能在打开受支持语言的文件后自动生效，无需手动操作。

## 常用命令

以下为 nvim-treesitter 提供的内置命令，可在 Neovim 命令行中直接使用。

### 解析器管理

| 命令 | 说明 |
|------|------|
| `:TSInstall <lang>` | 安装指定语言的解析器（支持 Tab 补全） |
| `:TSInstallInfo` | 查看所有可用语言及安装状态 |
| `:TSUpdate [lang]` | 更新指定语言的解析器；省略参数则更新所有已安装的解析器 |
| `:TSUninstall <lang>` | 卸载指定语言的解析器 |

### 模块控制

| 命令 | 说明 |
|------|------|
| `:TSBufEnable <module>` | 在当前 Buffer 启用指定模块（如 `highlight`、`indent`） |
| `:TSBufDisable <module>` | 在当前 Buffer 禁用指定模块 |
| `:TSEnable <module> [ft]` | 全局启用模块；可指定仅对某文件类型生效 |
| `:TSDisable <module> [ft]` | 全局禁用模块；可指定仅对某文件类型生效 |
| `:TSModuleInfo [module]` | 查看各文件类型的模块启用状态 |

### 其他

| 命令 | 说明 |
|------|------|
| `:checkhealth nvim-treesitter` | 运行健康检查，排查安装和解析器问题 |

启用或禁用模块后，可能需要重新加载 Buffer（`:e`）才能生效。

## 配置说明

配置文件路径：`lua/plugins/treesitter.lua`

### 基础配置

当前配置仅启用了语法高亮，并在插件加载时自动安装指定的语言解析器。

```lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "cmake", "python" },
      highlight = { enable = true },
    })
  end,
}
```

### 已安装的语言解析器

C、C++、Lua、Vim、Vimdoc、CMake、Python

### 安装新语言

将目标语言名称添加到 `ensure_installed` 列表中，下次启动 Neovim 时会自动安装：

```lua
ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "cmake", "python", "rust", "go" },
```

也可以在 Neovim 运行时手动安装：

```vim
:TSInstall rust
```

使用 `:TSInstallInfo` 查看所有可用语言。

### 启用增量选择（可选）

如需基于语法树的增量选择功能，可在配置中添加：

```lua
require("nvim-treesitter.config").setup({
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      scope_incremental = false,
      node_decremental = "<BS>",
    },
  },
})
```

### 启用缩进（可选）

如需基于语法树的自动缩进，可在配置中添加（实验性功能）：

```lua
require("nvim-treesitter.config").setup({
  indent = { enable = true },
})
```

### 启用折叠（可选）

基于语法树的代码折叠，由 Neovim 原生提供：

```lua
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
```

## 特性

- 基于语法树的精确语法高亮，正确处理嵌套、插值等复杂语法
- 插件安装时自动构建（`build = ":TSUpdate"`），无需手动执行安装命令
- 通过 `ensure_installed` 声明式管理语言，首次启动自动下载编译
- 模块化设计，支持按需启用高亮、增量选择、缩进、折叠等功能
