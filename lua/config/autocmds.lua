-- 复制时高亮选中的文本
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- [No Name] 缓冲区清理工具函数
local function is_orphan_no_name(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return false end
  if vim.api.nvim_buf_get_name(buf) ~= "" then return false end
  if vim.bo[buf].buftype ~= "" then return false end
  if vim.bo[buf].modified then return false end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return #lines == 1 and lines[1] == ""
end

local function is_buffer_displayed(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return true
    end
  end
  return false
end

local function clean_no_name_buffers(force)
  local to_delete = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_orphan_no_name(buf) and (force or not is_buffer_displayed(buf)) then
      table.insert(to_delete, buf)
    end
  end
  for _, buf in ipairs(to_delete) do
    if vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.api.nvim_buf_delete, buf, { force = force })
    end
  end
end

-- 打开目录时用 neo-tree 替代 netrw，并清理启动时的 [No Name] 缓冲区
-- auto-session 恢复会话时跳过此逻辑，避免冲突
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- auto-session 会处理会话恢复，不需要手动打开 neo-tree
    local ok, as = pcall(require, "auto-session")
    if ok and as.Lib and as.Lib.current_session_name then
      local name = as.Lib.current_session_name()
      if type(name) == "string" and name ~= "" then return end
    end
    if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      require("neo-tree")
      vim.cmd("Neotree")
      vim.schedule(function()
        clean_no_name_buffers(true)
      end)
    end
  end,
})

-- 打开文件时自动清理不在任何窗口中显示的 [No Name] 缓冲区
local _clean_depth = 0
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if _clean_depth > 0 then return end
    local name = vim.api.nvim_buf_get_name(0)
    if name ~= "" then
      _clean_depth = _clean_depth + 1
      clean_no_name_buffers(false)
      _clean_depth = _clean_depth - 1
    end
  end,
})

-- 外部工具（AI coding、git、rm 等）改动/删除文件时的优雅处理
-- - 文件被外部删除/移动：buffer 内容原样保留，柔和提示，不再报 E211
-- - 文件被外部修改但仍在：buffer 未修改则自动重载，有未保存改动则只提示
-- FileChangedShell 是 nvim 在检测到外部变化的任何时机统一触发的事件，
-- 配合 autoread 即可覆盖 FocusGained / BufEnter / CursorHold 等所有场景。
vim.o.autoread = true

vim.api.nvim_create_autocmd("FileChangedShell", {
  group = vim.api.nvim_create_augroup("external_file_change", { clear = true }),
  callback = function(event)
    local buf = event.buf
    if not vim.api.nvim_buf_is_valid(buf) then return end

    -- reason: 0=不明确 1=被修改 2=时间戳变 3=被删除 4=被移动
    local path = vim.api.nvim_buf_get_name(buf)
    local modified = vim.bo[buf].modified
    local exists = path ~= "" and vim.loop.fs_stat(path) ~= nil

    -- 文件已被删除或被移动：保留 buffer 内容，只给一条柔和提示
    if not exists then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.notify(
            ("文件已被外部删除或移动: %s\nbuffer 内容已保留，保存时会重新创建"):format(path),
            vim.log.levels.WARN,
            { title = "文件变化" }
          )
        end
      end)
      return
    end

    -- 文件被外部修改且仍在：未修改则让 autoread 自动重载；已修改只提示，绝不覆盖
    if event.reason == 1 or event.reason == 2 then
      if modified then
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(buf) then
            vim.notify(
              ("文件被外部修改，但 buffer 也有未保存改动，未自动重载: %s"):format(path),
              vim.log.levels.WARN,
              { title = "文件变化" }
            )
          end
        end)
      end
      -- modified == false 时交给 autoread 自动重载，无需提示
    end
  end,
})

-- 当没有系统剪贴板支持时（如 SSH 无 X11 forwarding），使用 OSC 52 复制到本地剪贴板
if vim.fn.has("clipboard") == 0 then
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("osc52_yank", { clear = true }),
    callback = function(event)
      local regname = event.regname ~= "" and event.regname or '"'
      local text = vim.fn.getreg(regname)
      if text == "" or #text > 100000 then
        return
      end
      local regtype = vim.fn.getregtype(regname)
      if regtype:sub(1, 1) == "V" and text:sub(-1) == "\n" then
        text = text:sub(1, -2)
      end
      -- OSC 52 转义序列，base64 编码后发送给终端
      local encoded = vim.base64.encode(text)
      local osc52 = string.format("\027]52;c;%s\007", encoded)
      local channel = vim.api.nvim_get_chan_info(0).stream
      if channel then
        vim.api.nvim_chan_send(channel, osc52)
      else
        io.stdout:write(osc52)
      end
    end,
  })
end
