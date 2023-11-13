local fix_import_declaration = {}

local utils = require("java.rename.utils")
local buffer = require("java.rename.buffer")
local ripgrep = require("java.rename.ripgrep")
local options = require("java.rename.options")


local function generate_import_regex(package_path)
    local mapped = package_path:gsub("%.", "%%.")

    return string.format(
        "import( +)%s( *);( *)(\n?)",
        mapped
    )
end

local function delete_import_declarations(new_folder, old_class_path)
    local opts = options.get_rename_options()

    local contents = utils.list_folder_contents(new_folder)

    for _, file in ipairs(contents) do
        local state = buffer.open(file)

        local regex = generate_import_regex(old_class_path)

        local lines = buffer.read_buffer_lines()

        local result = string.gsub(lines, regex, "")

        buffer.write_buffer_lines(result)

        if opts.write_and_close then
            vim.cmd.write()
            if not state then
                vim.cmd.bd()
            end
        end
    end
end

local function add_import_declerations(old_folder, new_class_path, old_class_name)
    local opts = options.get_rename_options()

    local contents = ripgrep.searchRegex(old_class_name, old_folder, 1)

    for _, file in ipairs(contents) do
        local state = buffer.open(old_folder .. "/" .. file)

        local lines = buffer.read_buffer_lines()

        local regex = "import( +)([A-Za-z%.]*)( *);"

        local start_index, end_index = string.find(lines, regex)

        local result = lines:sub(0, start_index - 1) .. "import " .. new_class_path .. ";\n" .. lines:sub(start_index, #lines)

        buffer.write_buffer_lines(result)

        if opts.write_and_close then
            vim.cmd.write()
            if not state then
                vim.cmd.bd()
            end
        end
    end
end

-- fix import declarations after the move to another package -> removes or adds import declarations
function fix_import_declaration.fix_import_declarations(old_folder, new_folder, old_class_path, new_class_path, old_class_name)
    delete_import_declarations(new_folder, old_class_path)

    add_import_declerations(old_folder, new_class_path, old_class_name)
end

return fix_import_declaration
