local ripgrep = {}

local utils = require("java.rename.utils")

-- search files in a given folder using a specific regex with ripgrep
-- @param regex to search for, should not use look-behind and look-ahead (not supported by ripgrep)
-- @param folder the folder to search for, may be nil. If nil, it will use the current PWD.
-- @param depth the maximum recursive depth for look through the folders, may be nil. If nill, it will look through all folders in the given folder.
function ripgrep.searchRegex(regex, folder, depth)
    if folder == nil then
        folder = "."
    end

    local args = ""
    if depth ~= nil then
        args = "--max-depth " .. depth .. " "
    end
    local command = string.format(
        "cd '%s' && rg --no-heading --no-messages --type java %s'%s'",
        folder,
        args,
        regex
    )
 
    local result = {}

    local handle = io.popen(command)

    while handle ~= nil do
        local line = handle:read("l")

        if line ~= nil then
            local splitted = utils.split(line, ":")
            local file = splitted[1]

            result[file] = true
        else
            break
        end
    end

    local t = {}
    for key, _ in pairs(result) do
        table.insert(t, key)
    end

    return t
end


return ripgrep
