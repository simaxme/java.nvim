local java_rename = {}

-- test
local utils = require("java-rename.utils")

-- will return the package name of a specified buffer
local function get_buffer_package_name(buf)
    if buf == nil then
        buf = "%"
    end

    -- get the folder name
    local head = vim.fn.expand("%:h")

    -- find the relative root path by splitting the array (should always be "main/java")
    local parts = utils.split(head, "main/java/")

    -- if main/java could not be found, cancel
    if #parts <= 1 then
        return
    end

    -- get the package name by replacing "/" with "."
    local package_name = parts[2]:gsub("/", ".")

    return package_name
end

-- renames the java file and will update the package names automatically
function java_rename.rename_file(old_name, new_name)
    -- open the file
    vim.cmd.edit(old_name)

    -- get package name
    local old_package_name = get_buffer_package_name()

    vim.cmd("echo 'package name: " .. old_package_name .. "'")

    -- move file in new path
    vim.cmd.write(new_name)
    vim.fn.delete(old_name)
    vim.cmd.edit(new_name)

end

return java_rename

