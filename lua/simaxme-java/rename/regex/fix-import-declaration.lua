local fix_import_declaration = {}

local utils = require("simaxme-java.rename.utils")
local buffer = require("simaxme-java.rename.buffer")
local ripgrep = require("simaxme-java.rename.ripgrep")
local options = require("simaxme-java.rename.options")
local file_refactor = require("simaxme-java.rename.file-refactor")

-- generate a regex for looking for import statements
-- @param class_path the class path to look for
function fix_import_declaration.generate_import_regex(class_path)
    local mapped = class_path:gsub("%.", "%%.")

    return string.format(
        "import( +)%s( *);( *)(\n?)",
        mapped
    )
end

-- look for old import declarations in the new folder/package and delete them
-- @param new_folder the folder where the class file was moved to
-- @param old_class_path the old_class_path whose import declarations should be deleted.
local function delete_import_declarations(new_folder, old_class_path)
    local opts = options.get_rename_options()

    local contents = utils.list_folder_contents(new_folder)

    for _, file in ipairs(contents) do
        -- local state = buffer.open(file)

        local regex = fix_import_declaration.generate_import_regex(old_class_path)

        local lines = file_refactor.get_file_content(file)

        local result = string.gsub(lines, regex, "")

        -- buffer.write_buffer_lines(result)
        file_refactor.add_rewrite_request(file, result)

        if opts.write_and_close then
            vim.cmd.write()
            if not state then
                vim.cmd.bd()
            end
        end
    end
end

--- will insert an import statement into the content
function fix_import_declaration.add_import_statement(content, statement)
    local regex = "import( +)([A-Za-z%.]*)( *)%;"

    local start_index, end_index = string.find(content, regex)

    -- if there is no import statement, insert the import statement after the package declaration
    if start_index == nil then
        local regex = "package( +)([A-Za-z%.]*)( *)%;( *)\n"
        start_index, end_index = string.find(content, regex)
        start_index = end_index+1

        statement = "\n" .. statement
    else
        statement = statement .. "\n"
    end

    return content:sub(0, start_index - 1) .. statement .. content:sub(start_index, #content)
end

-- add import declarations of the new class name to the classes of the old folder
-- @param old_folder the path of the old_folder
-- @param new_class_path the path of the new class
-- @param old_class_name the name of the old class
local function add_import_declerations(old_folder, new_class_path, old_class_name)
    local opts = options.get_rename_options()

    local contents = ripgrep.searchRegex(old_class_name, old_folder, 1)

    for _, file in ipairs(contents) do
        -- local state = buffer.open(old_folder .. "/" .. file)

        local path = old_folder .. "/" .. file

        -- local lines = buffer.read_buffer_lines()
        local lines = file_refactor.get_file_content(path)

        local addition = "import " .. new_class_path .. ";"

        local result = fix_import_declaration.add_import_statement(lines, addition)

        file_refactor.add_rewrite_request(path, result)
        -- buffer.write_buffer_lines(result)

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
