return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gitsigns = require("gitsigns")

    gitsigns.setup({
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged_enable = true,
      signcolumn = true,
      current_line_blame = false,
      on_attach = function(bufnr)
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- 导航
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "下一个 hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "上一个 hunk")

        -- 操作
        map("n", "<leader>hs", gitsigns.stage_hunk, "暂存 hunk")
        map("n", "<leader>hr", gitsigns.reset_hunk, "重置 hunk")
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "暂存选中 hunk")
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "重置选中 hunk")
        map("n", "<leader>hS", gitsigns.stage_buffer, "暂存整个缓冲区")
        map("n", "<leader>hR", gitsigns.reset_buffer, "重置整个缓冲区")
        map("n", "<leader>hp", gitsigns.preview_hunk, "预览 hunk")
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, "查看行 blame 信息")
        map("n", "<leader>hd", gitsigns.diffthis, "打开 diff")

        -- 切换
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "切换行末 blame")
        map("n", "<leader>tw", gitsigns.toggle_word_diff, "切换词级 diff")

        -- 文本对象
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "选择 hunk")
      end,
    })
  end,
}
