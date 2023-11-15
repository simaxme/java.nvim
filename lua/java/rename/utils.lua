local utils = {}

-- split a string
function utils.split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
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
