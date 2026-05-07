return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
          },
          n = {
            ["q"] = actions.close,
          },
        },
        file_ignore_patterns = { "node_modules", ".git/", "%.o$", "%.class$" },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui_select")

    -- 文件搜索
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "查找文件" })
    vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "全局搜索文本" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "查找已打开的 Buffer" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "最近打开的文件" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "查找帮助文档" })
    local function has_lsp()
      return #vim.lsp.get_clients({ bufnr = 0 }) > 0
    end
    vim.keymap.set("n", "<leader>fs", function()
      if has_lsp() then builtin.lsp_document_symbols()
      else vim.notify("当前 buffer 无 LSP 客户端", vim.log.levels.WARN) end
    end, { desc = "当前文件符号" })
    vim.keymap.set("n", "<leader>fW", function()
      if has_lsp() then builtin.lsp_workspace_symbols()
      else vim.notify("当前 buffer 无 LSP 客户端", vim.log.levels.WARN) end
    end, { desc = "工作区符号" })
    vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "查找命令" })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "查找快捷键" })
    vim.keymap.set("n", "<leader>ft", builtin.builtin, { desc = "Telescope 内置选择器" })

    -- Git
    local function in_git_repo()
      return vim.uv.fs_stat(".git") ~= nil
    end

    local function git_files()
      if in_git_repo() then builtin.git_files() else vim.notify("不在 Git 仓库中", vim.log.levels.WARN) end
    end
    local function git_commits()
      if in_git_repo() then builtin.git_commits() else vim.notify("不在 Git 仓库中", vim.log.levels.WARN) end
    end
    local function git_branches()
      if in_git_repo() then builtin.git_branches() else vim.notify("不在 Git 仓库中", vim.log.levels.WARN) end
    end
    local function git_status()
      if in_git_repo() then builtin.git_status() else vim.notify("不在 Git 仓库中", vim.log.levels.WARN) end
    end

    vim.keymap.set("n", "<leader>gf", git_files, { desc = "Git 文件" })
    vim.keymap.set("n", "<leader>gc", git_commits, { desc = "Git 提交记录" })
    vim.keymap.set("n", "<leader>gb", git_branches, { desc = "Git 分支" })
    vim.keymap.set("n", "<leader>gs", git_status, { desc = "Git 状态" })
  end,
}
