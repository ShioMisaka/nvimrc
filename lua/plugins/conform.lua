return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "格式化代码",
    },
    {
      "<leader>w",
      function()
        if vim.bo.buftype ~= "" then
          vim.notify("格式化保存仅适用于文件缓冲区", vim.log.levels.INFO)
          return
        end
        require("conform").format({ async = false, lsp_fallback = true })
        vim.cmd("w")
      end,
      desc = "格式化并保存",
    },
  },
  opts = {
    -- 未配置外部 formatter 时回退到 LSP 格式化
    default_format_opts = { lsp_format = "fallback" },

    -- 各语言格式化工具
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      cmake = { "cmake_format" },
    },

    -- clang-format：项目有自己的 .clang-format 时尊重它，否则回退到 4 空格风格
    -- 仅在向上找不到 .clang-format 时追加 --fallback-style，不覆盖团队/项目规范
    formatters = {
      ["clang-format"] = {
        -- WebKit 预定义风格即 4 空格缩进，避免内联多 key fallback 在新版 clang-format 上的解析问题
        prepend_args = { "--fallback-style=WebKit" },
      },
    },
  },
  init = function()
    -- gq 等操作使用 conform 代替内置 formatexpr
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
