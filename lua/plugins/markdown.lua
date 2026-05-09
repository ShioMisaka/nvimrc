return {
  -- 终端内 Markdown 渲染预览
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {},
    config = function(_, opts)
      require("render-markdown").setup(opts)
      vim.keymap.set("n", "<leader>mp", "<Cmd>RenderMarkdown toggle<CR>", { desc = "切换 Markdown 预览" })
    end,
  },
  -- Markdown 编辑工具（链接跳转等）
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    opts = {},
  },
  -- 表格编辑模式
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    init = function()
      -- Markdown 兼容的分隔符
      vim.g.table_mode_corner = "|"
    end,
    config = function()
      vim.keymap.set("n", "<leader>mt", "<Cmd>TableModeToggle<CR>", { desc = "切换表格编辑模式" })
    end,
  },
}
