return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "代码" },
      { "<leader>d", group = "诊断" },
      { "<leader>f", group = "查找" },
      { "<leader>g", group = "Git" },
      { "<leader>r", group = "重构" },
      { "<leader>s", group = "会话" },
      { "<leader>v", group = "垂直拆分" },
      { "<leader>x", group = "窗口" },
      { "<leader>w", desc = "格式化并保存", icon = "" },
      { "<leader>-", desc = "水平拆分窗口", icon = "" },
    },
  },
}
