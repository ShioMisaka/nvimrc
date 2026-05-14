return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "运行最近测试" },
      { "<leader>tF", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "运行文件测试" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "调试最近测试" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "运行上次测试" },
      { "<leader>ts", function() require("neotest").run.stop() end, desc = "停止测试" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "测试输出" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "测试输出面板" },
      { "<leader>tu", function() require("neotest").summary.toggle() end, desc = "测试概览" },
      { "<leader>tw", function() require("neotest").watch.toggle() end, desc = "测试监听" },
      { "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "下一个失败测试" },
      { "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "上一个失败测试" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
        },
      })
    end,
  },
}
