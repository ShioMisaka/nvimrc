return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require("cmp")

    -- 判断光标是否处于一对配对括号中间（如 (|) {|} [|}），用于 <CR> 拆行
    local function is_between_pair()
      local col = vim.fn.col(".")
      local line = vim.fn.getline(".")
      local prev = line:sub(col - 1, col - 1)
      local next = line:sub(col, col)
      local pairs = { ["("] = ")", ["{"] = "}", ["["] = "]" }
      return pairs[prev] == next
    end

    -- 在配对括号中间按 <CR>：把闭合括号踢到下一行，光标停在中间空行并自动缩进
    -- <CR><Esc>O 是经典技巧：<CR> 先把闭合括号挤到下一行，O 在其上方开新行，
    -- 此时 cindent 根据上方开括号所在行计算缩进（如 for(){ 内部为 8 空格），
    -- 避免了 <CR><CR> 序列里 cindent 因看到光标后的 } 而把中间行减到闭合级别的问题
    local function expand_pair_return()
      local keys = vim.api.nvim_replace_termcodes("<CR><Esc>O", true, true, true)
      vim.api.nvim_feedkeys(keys, "n", false)
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping(function(fallback)
          -- 光标在配对括号中间时拆行（即使 cmp 菜单可见也优先）；
          -- 否则保留原行为：菜单可见时确认补全，否则正常回车
          if is_between_pair() then
            expand_pair_return()
          elseif cmp.visible() then
            cmp.confirm({ select = true })
          else
            fallback()
          end
        end, { "i" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer", keyword_length = 3, option = { get_bufnrs = function() return { vim.api.nvim_get_current_buf() } end } },
        { name = "path" },
      }),
    })
  end,
}
