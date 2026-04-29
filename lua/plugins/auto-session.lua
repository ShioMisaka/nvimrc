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
  },
  init = function()
    -- auto-session 推荐的 sessionoptions，确保会话完整恢复
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
}
