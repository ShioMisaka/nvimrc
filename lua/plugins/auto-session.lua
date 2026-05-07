return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>ss", "<cmd>AutoSession search<CR>", desc = "搜索会话" },
    { "<leader>sd", "<cmd>AutoSession delete<CR>", desc = "删除当前会话" },
    { "<leader>st", "<cmd>AutoSession toggle<CR>", desc = "切换自动保存" },
  },
  opts = {
    -- auto-session 对 ~ 做精确匹配而非前缀匹配，不影响子目录
    suppressed_dirs = { "~/", "/", "~/.config/nvim" },
    auto_restore_last_session = false,
    close_filetypes_on_save = { "neo-tree", "toggleterm" },
    session_lens = {
      load_on_setup = true,
    },
    -- 恢复失败时用 silent! 重试，尽可能多地恢复会话内容
    continue_restore_on_error = true,
    -- 自定义错误处理：忽略恢复时的 E517 (bwipeout) 错误
    -- 原因：auto-session 在恢复前会先清空所有 buffer，但会话文件中也包含
    -- bwipe 命令，导致对已不存在的 buffer 执行 bwipe 时触发 E517
    restore_error_handler = function(error_msg)
      if error_msg then
        if string.find(error_msg, "E490: No fold found") or string.find(error_msg, "E16: Invalid range") then
          return true
        end
        if string.find(error_msg, "Vim(help):E661", 1, true) then
          return true
        end
        if string.find(error_msg, "E517") then
          return true
        end
      end
      return false
    end,
  },
  init = function()
    -- auto-session 推荐的 sessionoptions，确保会话完整恢复
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
}
