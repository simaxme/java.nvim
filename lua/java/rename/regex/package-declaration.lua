local package_declaration = {}

local buffer = require("java.rename.buffer")

-- generate a regex for looking for package declartions
local function generate_regex(package_path)
    local mapped = package_path:gsub("%.", "%%.")

    return string.format(
        "package( +)%s( *);",
        mapped
    )

end

-- will rename the package declaration in the renamed file
-- @param old_package_path the old package path
-- @param new_package_path the new package path
function package_declaration.replace_package_declaration(old_package_path, new_package_path)
    local lines = buffer.read_buffer_lines()
    local regex = generate_regex(old_package_path)

    local result = lines:gsub(regex, "package " .. new_package_path .. ";")

    buffer.write_buffer_lines(result)
end

return package_declaration
