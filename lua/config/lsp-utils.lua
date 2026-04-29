local M = {}

-- 判断路径是否属于需要排除的目录（build/install/moc 生成文件）
function M.is_excluded_path(path)
  if path:match("[/\\]build[/\\]") or path:match("[/\\]install[/\\]") then
    return true
  end
  if path:match("[/\\]moc_") or path:match("[/\\]ui_") or path:match("[/\\]qrc_") then
    return true
  end
  return false
end

-- 将 install/build 路径映射到对应的源码路径
function M.to_source_path(path)
  -- ROS2/colcon: workspace/install/pkg/... -> workspace/src/pkg/...
  local source = path:gsub("^(.-)[/\\]install[/\\]([^/\\]+)", "%1/src/%2")
  if source ~= path and vim.fn.filereadable(source) == 1 then return source end
  -- 通用: build/pkg/... -> src/pkg/...
  source = path:gsub("^(.-)[/\\]build[/\\]([^/\\]+)", "%1/src/%2")
  if source ~= path and vim.fn.filereadable(source) == 1 then return source end
  return nil
end

-- 跳转到 LSP Location（兼容 Location 和 LocationLink 两种类型）
function M.jump_to_location(loc)
  local uri = loc.targetUri or loc.uri
  local path = vim.uri_to_fname(uri)
  local buf = vim.fn.bufadd(path)
  -- 保存当前位置到 jumplist 和 tagstack
  local from = vim.fn.getpos(".")
  from[1] = vim.api.nvim_get_current_buf()
  vim.cmd("normal! m'")
  pcall(vim.fn.settagstack, vim.fn.win_getid(0), { items = { { tagname = "", from = from } } }, "t")
  vim.bo[buf].buflisted = true
  vim.api.nvim_win_set_buf(0, buf)
  -- LocationLink 使用 targetRange，Location 使用 range
  local range = loc.targetRange or loc.range
  vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
  vim.cmd("normal! zv")
end

-- 带过滤的 LSP 跳转：排除 build/install 目录，自动映射到源码路径
function M.filtered_lsp_jump(method)
  vim.lsp.buf.clear_references()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ method = method, bufnr = bufnr })
  if not next(clients) then return end

  vim.lsp.buf_request_all(bufnr, method, function(client)
    return vim.lsp.util.make_position_params(0, client.offset_encoding)
  end, function(results)
    local all_locs = {}
    for client_id, res in pairs(results) do
      if res.err then
        local client = vim.lsp.get_client_by_id(client_id)
        vim.notify(
          (client and client.name or "LSP") .. ": " .. tostring(res.err.message or res.err),
          vim.log.levels.WARN
        )
      elseif res.result then
        local locs = vim.islist(res.result) and res.result or { res.result }
        vim.list_extend(all_locs, locs)
      end
    end
    if vim.tbl_isempty(all_locs) then return end

    -- 先过滤掉排除路径
    local filtered = vim.tbl_filter(function(loc)
      local uri = loc.uri or loc.targetUri
      return uri and not M.is_excluded_path(vim.uri_to_fname(uri))
    end, all_locs)

    -- 如果全部被过滤，尝试将排除路径映射到源码路径
    if #filtered == 0 then
      filtered = {}
      for _, loc in ipairs(all_locs) do
        local uri = loc.uri or loc.targetUri
        local path = uri and vim.uri_to_fname(uri)
        local source = path and M.to_source_path(path)
        if source then
          table.insert(filtered, {
            uri = vim.uri_from_fname(source),
            range = loc.targetRange or loc.range,
          })
        end
      end
    end

    if #filtered == 0 then return end

    if #filtered == 1 then
      M.jump_to_location(filtered[1])
    else
      local entries = vim.tbl_map(function(loc)
        local uri = loc.uri or loc.targetUri
        local path = vim.uri_to_fname(uri)
        return {
          loc = loc,
          label = vim.fn.fnamemodify(path, ":~:.") .. ":" .. (loc.range.start.line + 1),
        }
      end, filtered)
      vim.ui.select(entries, {
        prompt = "Jump to:",
        format_item = function(e) return e.label end,
      }, function(choice)
        if choice then M.jump_to_location(choice.loc) end
      end)
    end
  end)
end

return M
