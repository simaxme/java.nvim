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

function utils.split_with_patterns(search_string, patterns)
  local result = {}

  for _, pattern in ipairs(patterns) do
    result = utils.split(search_string, pattern)

    if #result > 1 then
      break
    end
    -- The pattern could not be found
  end
  return result
end

-- check if a path is a directory
function utils.is_dir(path)
  local f = io.open(path, "r")
  local ok, err, code = f:read(1)
  f:close()
  return code == 21
end

-- list all files in a folder using recursive
function utils.list_folder_contents_recursive(folder)
  local result = {}

  local handle = io.popen("cd '" .. folder .. "' && find * -type f")

  while handle ~= nil do
    local line = handle:read("l")

    if line == nil then
      break
    end

    table.insert(result, line)
  end

  return result
end

-- list all files in a folder
function utils.list_folder_contents(folder)
  local result = {}

  local command = "cd '" .. folder .. "' && find * -maxdepth 0 -type f"
  local handle = io.popen(command)

  while handle ~= nil do
    local line = handle:read("l")

    if line == nil then
      break
    end

    local l = string.find(line, "%.java$")

    if l ~= nil then
      table.insert(result, folder .. "/" .. line)
    end
  end

  return result
end

-- get the real/full path of the given path
function utils.realpath(path)
  local cmd = "realpath '" .. path .. "'"
  local handle = io.popen(cmd)

  if handle == nil then
    return path
  end

  local result = handle:read("*l")

  handle:close()

  return result
end

return utils
