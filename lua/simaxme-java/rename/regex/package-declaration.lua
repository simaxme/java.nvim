local package_declaration = {}

-- local buffer = require("simaxme-java.rename.buffer")
local file_refactor = require("simaxme-java.rename.file-refactor")

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
function package_declaration.replace_package_declaration(file_path, old_package_path, new_package_path)
    local lines = file_refactor.get_file_content(file_path)
    local regex = generate_regex(old_package_path)

    local result = lines:gsub(regex, "package " .. new_package_path .. ";")

    -- buffer.write_buffer_lines(result)
    file_refactor.add_rewrite_request(file_path, result)
end

return package_declaration
