return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "切换文件浏览器" },
    { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "定位当前文件" },
  },
  opts = {
    close_if_last_window = false,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    -- 保存文件后主动触发 git status 异步刷新。
    -- use_libuv_file_watcher=true 时，BufWritePost 路径被跳过，文件树 git 状态要等
    -- libuv fs_event(100ms) → status_async(1000ms) → GIT_EVENT(100ms) 三层 debounce，
    -- 体感延迟约 1.2s。这里订阅 vim_buffer_changed 直接调 status_async，其内部
    -- CALL_FIRST_AND_LAST 策略让首次调用立即执行，绕过 1000ms 大延迟。
    event_handlers = {
      {
        event = "vim_buffer_changed",
        handler = function(args)
          local path = args.afile or ""
          if path == "" then return end
          local ok, git = pcall(require, "neo-tree.git")
          if not ok then return end
          local root = git.find_existing_worktree(path)
          if not root then return end
          local cfg = require("neo-tree").config
          if cfg and cfg.git_status_async_options then
            git.status_async(path, nil, cfg.git_status_async_options)
          end
        end,
      },
    },
    window = {
      position = "left",
      width = 30,
      mappings = {
        ["<space>"] = "none",
        ["h"] = "close_node",
        ["l"] = {
          function(state)
            local node = state.tree:get_node()
            if node.type == "directory" then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_id())
              state.commands.open(state)
            end
          end,
          desc = "展开文件夹或打开文件",
        },
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
            vim.notify("已复制: " .. path)
          end,
          desc = "复制路径到系统剪贴板",
        },
      },
    },
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
    },
  },
}
