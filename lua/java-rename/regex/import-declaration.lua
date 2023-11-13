local import_declaration = {}

local buffer = require("java-rename.buffer")

local function generate_regex(package_path)
    local mapped = package_path:gsub("%.", "%%.")

    return string.format(
        "import( +)%s( *);",
        mapped
    )

end

function import_declaration.replace_import_declaration(old_class_path, new_class_path)
    -- search import statements and replace them with new class path

    local regex = generate_regex(old_class_path)

    buffer.replace_buffer(regex, "import " .. new_class_path .. ";")

end

return import_declaration
