local moved_class_imports = {}

local utils = require("simaxme-java.rename.utils")
local symbol_usage = require("simaxme-java.rename.regex.symbol-usage")
-- local buffer = require("simaxme-java.rename.buffer")
local file_refactor = require("simaxme-java.rename.file-refactor")
local fix_import_declaration = require("simaxme-java.rename.regex.fix-import-declaration")

--- will add class imports to the moved file
-- @param old_folder the old folder path
-- @param old_package_name the old package name
function moved_class_imports.add_class_imports(file_path, old_folder, old_package_name)
    local buffer_content = file_refactor.get_file_content(file_path)

    -- load all classes inside the folder
    local contents = utils.list_folder_contents(old_folder)

    for _, file_name in ipairs(contents) do
        local found = string.find(file_name, "(.*)%.java") ~= nil

        if found then
            local parts = utils.split(file_name, "/")
            local last_part = parts[#parts]
            local class_name = utils.split(last_part, "%.java")[1]

            local regex = symbol_usage.generate_regex(class_name)

            local result = string.find(buffer_content, regex)
            if result ~= nil then
                local addition = "import " .. old_package_name .. "." .. class_name .. ";"

                buffer_content = fix_import_declaration.add_import_statement(buffer_content, addition)            
            end
        end
    end

    file_refactor.add_rewrite_request(file_path, buffer_content)
end

function moved_class_imports.remove_class_imports(file_path, new_folder, new_package_name)
    local buffer_content = file_refactor.get_file_content(file_path)

    local contents = utils.list_folder_contents(new_folder)

    for _, file_name in ipairs(contents) do
        local found = string.find(file_name, "(.*)%.java") ~= nil

        if found then
            local parts = utils.split(file_name, "/")
            local last_part = parts[#parts]
            local class_name = utils.split(last_part, "%.java")[1]

            local regex = fix_import_declaration.generate_import_regex(new_package_name .. "." .. class_name)

            buffer_content = string.gsub(buffer_content, regex, "")
        end
    end

    file_refactor.add_rewrite_request(file_path, buffer_content)
end

return moved_class_imports


