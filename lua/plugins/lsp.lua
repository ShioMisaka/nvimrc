return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lsp_utils = require("config.lsp-utils")

    -- clangd 自定义参数（必须在 enable 之前配置，避免 capabilities 被覆盖）
    vim.lsp.config("clangd", {
      capabilities = capabilities,
      cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
    })

    -- 启用的 LSP 服务器（内置 API 配置，Mason 管理二进制）
    local servers = { "lua_ls", "pyright", "neocmake" }
    for _, server in ipairs(servers) do
      vim.lsp.config(server, { capabilities = capabilities })
      vim.lsp.enable(server)
    end
    vim.lsp.enable("clangd")

    -- clangd: .h/.cpp 切换
    vim.api.nvim_create_user_command("ClangdSwitchSourceHeader", function()
      local clients = vim.lsp.get_clients({ name = "clangd", bufnr = 0 })
      if not next(clients) then
        vim.notify("clangd not attached", vim.log.levels.WARN)
        return
      end
      clients[1]:request("textDocument/switchSourceHeader", { uri = vim.uri_from_bufnr(0) }, function(err, result)
        if err then
          vim.notify(tostring(err.message), vim.log.levels.WARN)
        elseif result then
          vim.cmd("edit " .. vim.uri_to_fname(result))
        else
          vim.notify("No corresponding file found", vim.log.levels.WARN)
        end
      end)
    end, { desc = "Switch between source and header file" })

    -- 光标停留自动显示诊断弹窗
    vim.api.nvim_create_autocmd("CursorHold", {
      group = vim.api.nvim_create_augroup("AutoDiagnosticFloat", { clear = true }),
      callback = function()
        local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
        if #diagnostics > 0 then
          vim.diagnostic.open_float({ scope = "cursor" })
        end
      end,
    })

    -- LSP 附着时的通用快捷键
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        -- 避免多个 LSP 客户端重复设置键位
        if vim.b[ev.buf].lsp_keymaps_set then return end
        vim.b[ev.buf].lsp_keymaps_set = true

        local opts = { noremap = true, silent = true, buffer = ev.buf }
        local bmap = function(key, fn, desc)
          vim.keymap.set("n", key, fn, vim.tbl_extend("force", opts, { desc = desc }))
        end
        bmap("gd", function() lsp_utils.filtered_lsp_jump("textDocument/definition") end, "跳转到定义")
        bmap("gD", function() lsp_utils.filtered_lsp_jump("textDocument/declaration") end, "跳转到声明")
        bmap("gi", function() lsp_utils.filtered_lsp_jump("textDocument/implementation") end, "跳转到实现")
        bmap("gy", function() lsp_utils.filtered_lsp_jump("textDocument/typeDefinition") end, "跳转到类型定义")
        bmap("gr", function() lsp_utils.filtered_lsp_jump("textDocument/references") end, "查找引用")
        bmap("K", vim.lsp.buf.hover, "悬浮提示")
        bmap("<leader>rn", vim.lsp.buf.rename, "重命名")
        bmap("<leader>ca", vim.lsp.buf.code_action, "代码动作")
        bmap("<leader>de", vim.diagnostic.open_float, "错误详情")
        bmap("[d", vim.diagnostic.goto_prev, "上一个诊断")
        bmap("]d", vim.diagnostic.goto_next, "下一个诊断")
      end,
    })
  end,
}
