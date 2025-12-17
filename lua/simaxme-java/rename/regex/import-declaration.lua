local import_declaration = {}

-- local buffer = require("simaxme-java.rename.buffer")
local file_refactor = require("simaxme-java.rename.file-refactor")

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
function import_declaration.replace_import_declaration(file_path, old_class_path, new_class_path)
    -- search import statements and replace them with new class path

    local regex = generate_regex(old_class_path)

    file_refactor.replace_buffer(file_path, regex, "import " .. new_class_path .. ";")

end

return import_declaration
