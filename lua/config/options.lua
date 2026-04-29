local opt = vim.opt

-- 行号
opt.number = true           -- 显示绝对行号
opt.relativenumber = true   -- 显示相对行号（方便快速跳转，例如 5j, 3k）

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true        -- 将 tab 转换为空格
opt.autoindent = true       -- 自动缩进

-- 系统交互
if vim.fn.has("clipboard") == 1 then
  opt.clipboard:append("unnamedplus") -- 允许 Neovim 和系统共享剪贴板
end

-- 搜索
opt.ignorecase = true       -- 搜索时忽略大小写
opt.smartcase = true        -- 如果输入了大写字母，则不再忽略大小写

-- 外观
opt.termguicolors = true    -- 开启真彩色支持
opt.signcolumn = "yes"      -- 始终显示左侧图标列（防止 LSP 报错时屏幕抖动）
opt.cursorline = true       -- 高亮当前行

-- 其他
opt.updatetime = 250        -- 降低交换文件写入和 CursorHold 事件的延迟
opt.splitright = true       -- 垂直分割窗口时，新窗口在右侧
opt.splitbelow = true       -- 水平分割窗口时，新窗口在下方
opt.undofile = true         -- 持久化撤销历史
opt.scrolloff = 8           -- 光标始终离上下边缘至少 8 行
opt.timeoutlen = 300        -- 映射序列超时时间（毫秒）
opt.ttimeoutlen = 100       -- 终端键码超时（毫秒），不影响 Escape 响应
