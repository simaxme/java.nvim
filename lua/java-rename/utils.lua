local utils = {}

-- split a string
function utils.split(search_string, pattern)
  local result = {}
  local end_index = 1
  local start_index = 1

  while end_index ~= nil do
    start_index, end_index = string.find(search_string, pattern, 1, true)

    if start_index ~= nil and end_index ~= nil then
      table.insert(result, string.sub(search_string, 1, start_index - 1))
      search_string = string.sub(search_string, end_index + 1, #search_string)
    end
  end

  table.insert(result, search_string)

  return result
end

return utils
