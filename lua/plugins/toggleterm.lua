return {
  "akinsho/toggleterm.nvim",
  version = "^2",
  cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermExec" },
  keys = {
    { "<C-\\>", "<cmd>1 ToggleTerm<cr>", desc = "切换终端1 (水平)" },
    { "<leader>tf", "<cmd>2 ToggleTerm direction=float<cr>", desc = "浮动终端" },
    { "<leader>th", "<cmd>3 ToggleTerm direction=horizontal<cr>", desc = "水平终端" },
    { "<leader>tv", "<cmd>4 ToggleTerm direction=vertical size=60<cr>", desc = "垂直终端" },
  },
  opts = {
    size = 15,
    hide_numbers = true,
    shade_terminals = true,
    direction = "horizontal",
    float_opts = {
      border = "rounded",
      winblend = 0,
    },
  },
}
