require('inlay-hint').setup {
  virt_text_pos = 'inline',
  highlight_group = 'LspInlayHint',
  hl_mode = 'combine',

  -- display_callback = function(line_hints, options, bufnr, winid)
  --   local type_hints = {}
  --   local param_hints = {}
  --
  --   table.sort(line_hints, function(a, b) return a.position.character < b.position.character end)
  --
  --   for _, hint in ipairs(line_hints) do
  --     local label = hint.label
  --     local text = type(label) == 'string' and label or vim.iter(label):fold('', function(acc, part) return acc .. part.value end)
  --
  --     if hint.kind == 1 then
  --       local cleaned = text:gsub('^:%s*', '')
  --       table.insert(type_hints, cleaned)
  --     else
  --       local cleaned = text:gsub(':$', '')
  --       table.insert(param_hints, cleaned)
  --     end
  --   end
  --
  --   local out = {}
  --   if #param_hints > 0 then table.insert(out, '<- (' .. table.concat(param_hints, ', ') .. ')') end
  --   if #type_hints > 0 then table.insert(out, '=> ' .. table.concat(type_hints, ', ')) end
  --
  --   return table.concat(out, ' ')
  -- end,
}
