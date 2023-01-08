local convert = require('ddu-vim-ui-select.compat').convert
local iter = require('ddu-vim-ui-select.compat').iter

local ddu_ui_select = {}
local save_on_choice = nil
local save_items = nil

ddu_ui_select.select = function(items, opts, on_choice)
  opts = opts or {}
  opts.format_item = opts.format_item or function(e)
    return tostring(e)
  end

  local indexed_items = {}
  for idx, item in iter(items) do
    local text = opts.format_item(item)
    table.insert(indexed_items, { idx = idx, text = text })
  end

  save_on_choice = on_choice
  save_items = items

  vim.fn['ddu#start'](convert {
    sources = { {
      name = 'ui_select',
      params = { items = indexed_items },
    } },
  })
end

ddu_ui_select.on_choice = function(idx)
  if save_on_choice ~= nil then
    local on_choice = save_on_choice
    local items = save_items
    save_on_choice = nil
    save_items = nil
    on_choice(items[idx], idx)
  end
end

return ddu_ui_select
