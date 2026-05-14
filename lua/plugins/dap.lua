return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "继续调试" },
      { "<F10>", function() require("dap").step_over() end, desc = "单步跳过" },
      { "<F11>", function() require("dap").step_into() end, desc = "单步进入" },
      { "<F12>", function() require("dap").step_out() end, desc = "单步跳出" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "切换断点" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("条件断点: ")) end, desc = "条件断点" },
      { "<leader>dr", function() require("dap").run_last() end, desc = "重新运行" },
      {
        "<leader>ds",
        function()
          require("dap").terminate()
          require("dapui").close()
        end,
        desc = "终止调试",
      },
      { "<leader>du", function() require("dapui").toggle() end, desc = "调试界面" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- 调试会话开始/结束时自动开关 UI
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Python 调试适配器（Mason 安装的 debugpy）
      local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      if vim.fn.filereadable(debugpy) == 1 then
        require("dap-python").setup(debugpy)
      end
    end,
  },
}
