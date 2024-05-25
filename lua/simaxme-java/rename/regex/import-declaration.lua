local import_declaration = {}

local buffer = require("simaxme-java.rename.buffer")

-- generate a regex for finding old class path imports
local function generate_regex(package_path)
    local mapped = package_path:gsub("%.", "%%.")

    return string.format(
        "import( +)%s( *);",
        mapped
    )

end

-- will replace old class path imports with new class path imports
-- @param old_class_path the old class path
-- @param new_class_path the new class path
function import_declaration.replace_import_declaration(old_class_path, new_class_path)
    -- search import statements and replace them with new class path

    local regex = generate_regex(old_class_path)

    buffer.replace_buffer(regex, "import " .. new_class_path .. ";")

end

return import_declaration
