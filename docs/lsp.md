# LSP（语言服务器协议）

通过语言服务器提供代码智能功能：跳转定义、查找引用、悬浮文档、重命名、代码动作和诊断导航。跳转功能自动过滤 `build/` 和 `install/` 目录，并支持将编译产物路径映射回源码。

## 快捷键

LSP 快捷键在 LSP 附加到 Buffer 后自动生效，使用 `g` 前缀进行跳转，`<Space>` 前缀进行代码操作和诊断导航。

### 跳转

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gd` | normal | 跳转到定义（自动过滤 build/install 路径） |
| `gD` | normal | 跳转到声明 |
| `gi` | normal | 跳转到实现 |
| `gy` | normal | 跳转到类型定义 |
| `gr` | normal | 查找引用 |

多个候选位置时弹出 `vim.ui.select` 列表供选择。

### 代码操作

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `K` | normal | 悬浮提示（查看文档） |
| `<Space>rn` | normal | 重命名符号 |
| `<Space>ca` | normal | 代码动作（快速修复等） |

### 诊断导航

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `[d` | normal | 上一个诊断 |
| `]d` | normal | 下一个诊断 |
| `<Space>de` | normal | 显示当前行错误详情浮窗 |

光标停留时自动弹出诊断浮窗。

### clangd 专属

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<A-o>` | normal | 在 `.cpp` 和 `.h` 之间切换 |

> 注意：`<A-o>` 定义在 `lua/config/keymaps.lua` 中，其余 LSP 快捷键均在 `lua/plugins/lsp.lua` 的 `LspAttach` 自动命令中设置。

## 常用命令

### LSP 管理命令

以下命令由 Neovim 内置提供（`:help lsp`）：

| 命令 | 说明 |
|------|------|
| `:LspInfo` | 查看当前 Buffer 附加的 LSP 服务器状态 |
| `:LspStart [server]` | 手动启动 LSP 服务器（可指定服务器名） |
| `:LspStop [server]` | 停止当前 Buffer 的 LSP 服务器 |
| `:LspRestart [server]` | 重启当前 Buffer 的 LSP 服务器 |
| `:LspLog` | 打开 LSP 日志文件 |

### 诊断命令

Neovim 内置 `vim.diagnostic` 模块提供以下命令（`:help diagnostic-api`）：

| 命令 | 说明 |
|------|------|
| `:vim.diagnostic.open_float` | 在光标位置弹出诊断浮窗 |
| `:vim.diagnostic.goto_prev` | 跳转到上一个诊断位置 |
| `:vim.diagnostic.goto_next` | 跳转到下一个诊断位置 |
| `:vim.diagnostic.setloclist` | 将当前 Buffer 的诊断填入 location list（`:lopen` 查看） |
| `:vim.diagnostic.setqflist` | 将诊断填入 quickfix list（`:copen` 查看） |
| `:vim.diagnostic.disable [bufnr]` | 禁用诊断（可指定 Buffer，不指定则全局禁用） |
| `:vim.diagnostic.enable [bufnr]` | 启用诊断 |

实用组合示例：

```vim
" 查看当前文件所有诊断（location list）
:lua vim.diagnostic.setloclist()
:lopen

" 查看项目所有诊断（quickfix list）
:lua vim.diagnostic.setqflist()
:copen

" 临时关闭诊断显示
:lua vim.diagnostic.disable()

" 重新启用诊断
:lua vim.diagnostic.enable()
```

## 配置说明

配置文件路径：`lua/plugins/lsp.lua`。跳转过滤逻辑提取在 `lua/config/lsp-utils.lua` 中。

### 启用 LSP 服务器

通过 `servers` 列表声明需要启用的服务器，Mason 负责安装二进制文件：

```lua
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "clangd", "lua_ls", "pyright", "neocmake" }
for _, server in ipairs(servers) do
  vim.lsp.config(server, { capabilities = capabilities })
  vim.lsp.enable(server)
end
```

### clangd 自定义参数

为 clangd 配置额外的启动参数，启用后台索引、clang-tidy 和头文件自动插入：

```lua
vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
})
```

### 添加新的 LSP 服务器

将服务器名称加入 `servers` 列表即可：

```lua
local servers = { "clangd", "lua_ls", "pyright", "neocmake", "rust_analyzer" }
```

如需自定义参数，在循环之前使用 `vim.lsp.config()` 覆盖：

```lua
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
    },
  },
})
```

### 诊断浮窗

光标停留时自动弹出当前行的诊断信息：

```lua
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("AutoDiagnosticFloat", {}),
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
    if #diagnostics > 0 then
      vim.diagnostic.open_float({ scope = "cursor" })
    end
  end,
})
```

### 跳转过滤

跳转定义/声明/实现时，自动排除以下路径：
- `build/` 和 `install/` 目录下的文件
- `moc_`、`ui_`、`qrc_` 等自动生成文件

当所有结果都被过滤时，会尝试将路径映射回源码（如 `install/pkg/` -> `src/pkg/`）。多个候选目标时弹出选择列表。

### clangd 源文件/头文件切换

通过自定义命令实现 `.cpp`/`.h` 之间的一键切换：

```lua
vim.api.nvim_create_user_command("ClangdSwitchSourceHeader", function()
  vim.lsp.buf_request(0, "textDocument/switchSourceHeader", { uri = vim.uri_from_bufnr(0) }, function(_, result)
    if result then
      vim.cmd("edit " .. vim.uri_to_fname(result))
    else
      vim.notify("No corresponding file found", vim.log.levels.WARN)
    end
  end)
end, { desc = "Switch between source and header file" })
```

## 特性

- 自动过滤 build/install 目录和自动生成文件，跳转直达源码
- 路径自动映射：编译产物路径可映射回对应的源码路径（支持 ROS2/colcon 和通用 build 结构）
- 多候选时弹出 `vim.ui.select` 列表供选择
- 光标停留自动显示诊断浮窗
- clangd 支持源文件/头文件一键切换（`<A-o>`）
- 通过 nvim-cmp 集成补全（`cmp-nvim-lsp` 提供补全能力）
