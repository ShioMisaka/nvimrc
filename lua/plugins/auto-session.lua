return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>ss", "<cmd>AutoSession search<CR>", desc = "搜索会话" },
    { "<leader>sd", "<cmd>AutoSession delete<CR>", desc = "删除当前会话" },
    { "<leader>st", "<cmd>AutoSession toggle<CR>", desc = "切换自动保存" },
  },
  opts = function()
    local autosession = require("auto-session")
    return {
      -- auto-session 对 ~ 做精确匹配而非前缀匹配，不影响子目录
      suppressed_dirs = { "~/", "/", "~/.config/nvim" },
      auto_restore_last_session = false,
      close_filetypes_on_save = { "neo-tree", "toggleterm" },
      session_lens = {
        load_on_setup = true,
      },
      -- 恢复时忽略 buffer 已不存在的错误，不中断恢复也不禁用 auto save
      restore_error_handler = function(msg)
        if msg and msg:find("E517") then
          return true
        end
        return autosession.default_restore_error_handler(msg)
      end,
    }
  end,
  init = function()
    -- auto-session 推荐的 sessionoptions，确保会话完整恢复
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
}
