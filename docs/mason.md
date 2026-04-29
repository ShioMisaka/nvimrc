# Mason（LSP 包管理器）

便携式 Neovim 外部工具包管理器，可自动安装和管理 LSP 服务器、DAP 调试器、Linter、Formatter 等，无需手动配置 PATH 或编译安装。

## 常用命令

Mason 提供了一组 Ex 命令用于包管理，在 Neovim 任意位置均可使用：

| 命令 | 说明 |
|------|------|
| `:Mason` | 打开 Mason 图形化管理界面 |
| `:MasonInstall <package> ...` | 安装指定包（支持空格分隔多个包名） |
| `:MasonUninstall <package> ...` | 卸载指定包 |
| `:MasonUninstallAll` | 卸载所有已安装的包 |
| `:MasonUpdate` | 更新所有已安装的包及包注册表 |
| `:MasonLog` | 在新 tab 中打开 Mason 日志文件 |

示例：

```vim
:MasonInstall clangd lua_ls pyright
:MasonUninstall clangd
:MasonUpdate
```

## 快捷键

Mason 本身没有定义专属快捷键。管理界面内的操作依赖 Mason 内置的界面快捷键和全局快捷键。

### 界面内操作

Mason 管理界面（`:Mason`）内置以下快捷键（均为 Mason 默认配置）：

| 快捷键 | 说明 |
|--------|------|
| `<CR>` | 展开/收起包详情，或切换安装日志 |
| `i` | 安装光标所在包 |
| `u` | 重新安装/更新光标所在包 |
| `X` | 卸载光标所在包 |
| `c` | 检查光标所在包是否有新版本 |
| `C` | 检查所有已安装包的版本状态 |
| `U` | 更新所有已安装的包 |
| `<C-c>` | 取消当前安装任务 |
| `<C-f>` | 按语言过滤包列表 |
| `g?` | 切换帮助视图 |

### 退出管理界面

Mason 界面依赖全局快捷键进行退出操作：

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `jk` / `kj` | insert / terminal | 退出到 Normal 模式 |
| `q` | normal | 关闭当前 buffer |

## 配置说明

Mason 的插件定义位于 `lua/plugins/mason.lua`，当前配置极为简洁，仅自定义了 UI 边框样式。

### 基本配置

```lua
-- lua/plugins/mason.lua
return {
  "williamboman/mason.nvim",
  cmd = "Mason",           -- 延迟加载：仅在使用 :Mason 命令时加载
  build = ":MasonUpdate",  -- 安装/更新插件时自动执行 :MasonUpdate
  opts = {
    ui = { border = "rounded" },  -- 使用圆角边框
  },
}
```

### 自定义界面快捷键

如需修改 Mason 界面内的快捷键，可在 `opts.ui.keymaps` 中覆盖默认值：

```lua
return {
  "williamboman/mason.nvim",
  opts = {
    ui = {
      border = "rounded",
      keymaps = {
        toggle_package_expand = "<CR>",
        install_package = "i",
        update_package = "u",
        uninstall_package = "X",
        check_package_version = "c",
        check_outdated_packages = "C",
        update_all_packages = "U",
        cancel_installation = "<C-c>",
        apply_language_filter = "<C-f>",
        toggle_package_install_log = "<CR>",
        toggle_help = "g?",
      },
    },
  },
}
```

### 自定义 UI 外观

Mason 支持自定义包状态图标和窗口尺寸：

```lua
return {
  "williamboman/mason.nvim",
  opts = {
    ui = {
      border = "rounded",
      width = 0.8,   -- 窗口宽度（0-1 为屏幕比例，整数则为固定列数）
      height = 0.9,  -- 窗口高度（0-1 为屏幕比例，整数则为固定行数）
      backdrop = 60, -- 背景透明度（0 为完全不透明，100 为完全透明）
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
```

### 与 LSP 配合使用

Mason 负责下载 LSP 服务器的二进制文件，实际启用哪些服务器在 `lua/plugins/lsp.lua` 中配置：

```lua
-- lua/plugins/lsp.lua 中定义需要启用的 LSP 服务器
local servers = { "clangd", "lua_ls", "pyright", "neocmake" }
for _, server in ipairs(servers) do
  vim.lsp.config(server, { capabilities = capabilities })
  vim.lsp.enable(server)
end
```

如需添加新的语言服务器，只需在 `servers` 列表中加入对应名称，Mason 会自动下载并安装。完整可用包列表参见 https://mason-registry.dev/registry/list。

## 特性

- 延迟加载（`cmd = "Mason"`），不占用启动时间
- 安装或更新插件时自动执行 `:MasonUpdate`，保持已安装包为最新版本
- 圆角边框 UI，与整体视觉风格一致
- 作为 LSP 配置的后端，自动管理 `clangd`、`lua_ls`、`pyright`、`neocmake` 等服务器的二进制文件
- 界面内置语言过滤（`<C-f>`），快速定位目标语言的包
- 打开管理界面时自动检查包版本更新
