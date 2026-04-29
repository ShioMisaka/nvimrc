# nvim-lastplace（智能光标位置记忆）

重新打开文件时自动跳转到上次编辑的位置，并对特殊 buffer（Git 提交、帮助文档等）和刚创建的文件智能过滤，避免不必要的跳转。

## 工作原理

Neovim 原生通过 `'"` 标记记录上次退出时的光标位置，但默认行为会无条件跳转。`nvim-lastplace` 在 `BufReadPost` 事件中读取该标记，并附加以下过滤条件：

- 不跳转 `quickfix`、`nofile`、`help` 等 buftype
- 不跳转 `gitcommit`、`gitrebase`、`svn` 等 filetype
- 跳转时自动展开被折叠的代码（`lastplace_open_folds`）

## 配置说明

插件定义位于 `lua/plugins/nvim-lastplace.lua`，使用 `BufReadPost` 事件延迟加载，不占用启动时间。

### 基本配置

```lua
-- lua/plugins/nvim-lastplace.lua
return {
  "ethanholz/nvim-lastplace",
  event = "BufReadPost",
  opts = {
    -- 以下 buftype 的 buffer 不跳转到上次位置
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    -- 以下 filetype 的 buffer 不跳转到上次位置
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    -- 跳转时自动展开折叠
    lastplace_open_folds = true,
  },
}
```

### 自定义过滤规则

根据需要增减过滤的 buftype 或 filetype：

```lua
opts = {
  lastplace_ignore_buftype = { "quickfix", "nofile", "help", "terminal" },
  lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit", "NeogitCommitMessage" },
}
```

## 特性

- 延迟加载（`event = "BufReadPost"`），零启动开销
- 智能过滤特殊 buffer，不会在 Git 提交消息或帮助文档中意外跳转
- 跳转时自动展开折叠，确保光标位置的上下文可见
