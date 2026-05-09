return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "cmake", "python", "markdown", "markdown_inline" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
