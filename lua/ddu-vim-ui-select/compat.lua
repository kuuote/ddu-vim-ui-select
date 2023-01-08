if vim.fn.has('nvim') == 1 then
  return {
    convert = function(obj)
      return obj
    end,
    iter = ipairs,
  }
end

-- hack
vim.type_idx = true
vim.types = {
  [3] = 'float',
  [5] = 'array',
  [6] = 'dictionary',
  array = 5,
  dictionary = 6,
  float = 3,
}
vim.empty_dict = function()
  return {
    [vim.type_idx] = vim.types.dictionary,
  }
end

local function islist(tbl)
  if tbl[vim.type_idx] ~= nil then
    return tbl[vim.type_idx] == vim.types.array
  end
  local nums = 0
  local others = 0
  for k in pairs(tbl) do
    if type(k) == 'number' then
      nums = nums + 1
    else
      others = others + 1
    end
  end
  return others == 0 and nums == #tbl
end

local M = {}

function M.convert(obj)
  if type(obj) == 'table' then
    local newobj = {}
    for k, v in pairs(obj) do
      newobj[k] = M.convert(v)
    end
    if islist(newobj) then
      return vim.list(newobj)
    else
      return vim.dict(newobj)
    end
    return newobj
  end
  return obj
end

function M.iter(list)
  if type(list) == 'table' then
    return ipairs(list)
  else
    local iter = list()
    local idx = 0
    return function()
      local v = iter()
      if v ~= nil then
        idx = idx + 1
        return idx, v
      end
      return nil, nil
    end
  end
end

return M
