return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function(_, opts)
    require("mason").setup(opts)
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "lua_ls", "pyright", "neocmake" },
    })
  end,
  opts = {
    ui = { border = "rounded" },
  },
}
