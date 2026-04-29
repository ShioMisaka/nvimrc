local map = vim.keymap.set

-- 轻量弹出选择器：j/k 移动，CR 确认，Esc/C-c/q 取消
local function popup_select(title, items, on_select)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  local max_len = #title
  for _, item in ipairs(items) do
    if #item > max_len then max_len = #item end
  end
  local width = max_len + 4
  local height = math.min(#items, math.floor(vim.o.lines * 0.6))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, items)

  local idx = 0
  local ns = vim.api.nvim_create_namespace("popup_select")
  local function update()
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, ns, "Visual", idx, 0, -1)
  end
  update()

  local closed = false
  local function close()
    if closed then return end
    closed = true
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    pcall(vim.api.nvim_win_close, win, true)
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end

  -- 防止窗口被外部关闭时 buffer/keymap 残留
  vim.api.nvim_create_autocmd("WinClosed", {
    once = true,
    pattern = tostring(win),
    callback = close,
  })

  local opts = { noremap = true, buffer = buf }
  vim.keymap.set("n", "j", function()
    if idx < #items - 1 then idx = idx + 1; update() end
  end, opts)
  vim.keymap.set("n", "k", function()
    if idx > 0 then idx = idx - 1; update() end
  end, opts)
  vim.keymap.set("n", "<CR>", function()
    close()
    on_select(items[idx + 1])
  end, opts)
  vim.keymap.set("n", "<Esc>", close, opts)
  vim.keymap.set("n", "<C-c>", close, opts)
  vim.keymap.set("n", "q", close, opts)
  vim.api.nvim_set_current_win(win)
end

-- 上下移动当前行 (Alt + j/k)
map("n", "<A-j>", ":m .+1<CR>==", { desc = "向下移动当前行", silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "向上移动当前行", silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "向下移动选中行", silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "向上移动选中行", silent = true })

-- 窗口焦点切换 (Ctrl + h/j/k/l)
map("n", "<C-h>", "<C-w>h", { desc = "切换到左侧窗口", silent = true })
map("n", "<C-j>", "<C-w>j", { desc = "切换到下方窗口", silent = true })
map("n", "<C-k>", "<C-w>k", { desc = "切换到上方窗口", silent = true })
map("n", "<C-l>", "<C-w>l", { desc = "切换到右侧窗口", silent = true })

-- 窗口拆分
map("n", "<leader>v", "<C-w>v", { desc = "垂直拆分窗口", silent = true })
map("n", "<leader>-", "<C-w>s", { desc = "水平拆分窗口", silent = true })
map("n", "<leader>x", "<C-w>c", { desc = "关闭当前窗口", silent = true })

-- 清除搜索高亮 (按 Esc 时)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "清除搜索高亮", silent = true })

-- 行首行尾跳转
map("n", "gh", "0", { desc = "移动到行首", silent = true })
map("n", "gl", "$", { desc = "移动到行尾", silent = true })

-- .cpp 和 .h 之间跳转
map("n", "<A-o>", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header" })

-- 关闭当前 buffer（未保存时弹出确认，最后一个 buffer 时显示空白页）
map("n", "q", function()
  local close_buf = function(force)
    local listed_count = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buflisted and vim.api.nvim_buf_is_loaded(buf) then
        listed_count = listed_count + 1
      end
    end
    if listed_count <= 1 then
      local old_buf = vim.api.nvim_get_current_buf()
      vim.cmd("noautocmd enew")
      vim.bo.buflisted = true
      vim.bo.buftype = ""
      pcall(vim.api.nvim_buf_delete, old_buf, { force = force })
    else
      if vim.fn.exists(":Bdelete") > 0 then
        vim.cmd(force and "Bdelete!" or "Bdelete")
      else
        vim.cmd(force and "bdelete!" or "bdelete")
      end
    end
  end
  if vim.bo.modified then
    popup_select("Unsaved changes. Save before closing?", { "Save & Close", "Discard & Close", "Cancel" }, function(choice)
      if choice == "Save & Close" then
        if vim.api.nvim_buf_get_name(0) ~= "" then
          vim.cmd("w")
          close_buf(false)
        else
          close_buf(true)
        end
      elseif choice == "Discard & Close" then
        close_buf(true)
      end
    end)
  elseif vim.bo.buftype == "terminal" then
    close_buf(true)
  else
    close_buf(false)
  end
end, { desc = "关闭当前 buffer" })
map("v", "q", "<Esc>", { silent = true })

-- jk 退出编辑模式
-- 宏录制映射到 Q（q 在 normal/visual 模式已用于关闭 buffer）
map("n", "Q", "<Cmd>normal! q<CR>", { noremap = true, desc = "录制/停止宏" })

-- jk 退出编辑模式
map("i", "jk", "<Esc>", { silent = true })
map("i", "kj", "<Esc>", { silent = true })
map("t", "jk", "<C-\\><C-n>", { silent = true })
map("t", "kj", "<C-\\><C-n>", { silent = true })

-- 退出 Neovim（存在未保存文件时弹出确认）
map("n", "<leader>q", function()
  local has_modified = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].modified and vim.bo[buf].buflisted then
      has_modified = true
      break
    end
  end
  if has_modified then
    popup_select("Unsaved buffers exist. Save all before quitting?", { "Save All & Quit", "Quit Without Saving", "Cancel" }, function(choice)
      if choice == "Save All & Quit" then
        vim.cmd("wa")
        vim.cmd("qa")
      elseif choice == "Quit Without Saving" then
        vim.cmd("qa!")
      end
    end)
  else
    vim.cmd("qa")
  end
end, { desc = "退出 Neovim" })
