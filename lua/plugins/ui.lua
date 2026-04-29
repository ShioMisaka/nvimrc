return {
  -- 主题插件：Tokyonight (暗夜东京，非常受欢迎的主题)
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- 确保在启动时立即加载
    priority = 1000, -- 确保在其他插件前加载
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- 顶部标签栏
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
    event = "VeryLazy",
    keys = {
      { "<A-l>", "<cmd>BufferLineCycleNext<cr>", desc = "下一个 buffer" },
      { "<A-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "上一个 buffer" },
      { "<A-S-l>", "<cmd>BufferLineMoveNext<cr>", desc = "向右移动 buffer" },
      { "<A-S-h>", "<cmd>BufferLineMovePrev<cr>", desc = "向左移动 buffer" },
      { "<A-1>", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "跳转到第1个 buffer" },
      { "<A-2>", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "跳转到第2个 buffer" },
      { "<A-3>", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "跳转到第3个 buffer" },
      { "<A-4>", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "跳转到第4个 buffer" },
      { "<A-5>", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "跳转到第5个 buffer" },
      { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "选择关闭 buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "关闭其他 buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        sort_by = "insert_after_current",
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    },
  },

  -- 底部状态栏
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
      },
    },
  },
}
