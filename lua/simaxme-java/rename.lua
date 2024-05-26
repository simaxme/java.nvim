local java_rename = {}

local utils = require("simaxme-java.rename.utils")
local ripgrep = require("simaxme-java.rename.ripgrep")
local buffer = require("simaxme-java.rename.buffer")

local regex_class_declaration = require("simaxme-java.rename.regex.class-declaration")
local regex_package_declaration = require("simaxme-java.rename.regex.package-declaration")
local regex_import_declaration = require("simaxme-java.rename.regex.import-declaration")
local regex_symbol_usage = require("simaxme-java.rename.regex.symbol-usage")
local regex_fix_import_declaration = require("simaxme-java.rename.regex.fix-import-declaration")
local regex_moved_class_imports = require("simaxme-java.rename.regex.moved-class-imports")

local rename_options = require("simaxme-java.rename.options")
local options = require("simaxme-java.options")


-- function that returns the package name of a given path
-- will look for the folder main/java or test/java to identify the package name
-- @param path the full path of the package
-- @return the package_name in dot-seperated format
local function get_package_name(path)
    local root_markers = options.get_java_options().root_markers

    -- find the relative root path by splitting the array, which is defined by options.root_markers
    local parts = utils.split_with_patterns(path, root_markers)

    -- if any of the root markers could not be found, cancel
    if #parts <= 1 then
        return nil
    end

    -- get the package name by replacing "/" with "."
    local package_name = parts[2]:gsub("/", ".")

    return package_name
end

-- function for completly renaming a file and updating the imports
-- will automatically rename the file
-- not recommended
-- @param old_name the old/current file path that should be absolute or relative to the project root
-- @param new_name the new file path that should be absolute or relative to the project root
function java_rename.rename_file(old_name, new_name)
    -- open the file
    vim.cmd.edit(old_name)

    -- move file in new path
    vim.cmd.write(new_name)
    vim.fn.delete(old_name)
    vim.cmd.edit(new_name)

    java_rename.on_rename_file(old_name, new_name)
end


-- handles a file rename and will update each java class file automatically
-- this function should be executed *after* the file was renamed
-- @param old_name the old/current file path that should be absolute or relative to the project root
-- @param new_name the old/current file path that should be absolute or relative to the project root
-- @param whether the file rename is associated with a package rename
function java_rename.on_rename_file(old_name, new_name, is_package_rename)
    -- extract the folder names from the file names, removes the last part of the path
    local old_folder = old_name:gsub("%/([%w%.]*)$", "")
    local new_folder = new_name:gsub("%/([%w%.]*)$", "")

    -- extract the class names from the path by removing the folder part and the file extension
    local old_class_name = old_name:gsub("^%/(.*)%/", ""):gsub("%.(%w*)$", "")
    local new_class_name = new_name:gsub("^%/(.*)%/", ""):gsub("%.(%w*)$", "")

    -- get package name
    local old_package_name = get_package_name(old_folder)
    local new_package_name = get_package_name(new_folder)

    -- if package name could not be found, cancel the rename event
    if old_package_name == nil or new_package_name == nil then
        return
    end

    -- generate class pathes from the package names and class names
    local old_class_path = old_package_name .. "." .. old_class_name
    local new_class_path = new_package_name .. "." .. new_class_name

    local opts = rename_options.get_rename_options()

    -- replace class name declaration in class file
    local state = buffer.open(new_name)

    -- fix class and package declaration for the renamed buffer
    regex_class_declaration.replace_class_declaration(old_class_name, new_class_name)
    regex_package_declaration.replace_package_declaration(old_package_name, new_package_name)

    if not is_package_rename then
        regex_moved_class_imports.add_class_imports(old_folder, old_package_name)
        regex_moved_class_imports.remove_class_imports(new_folder, new_package_name)
    end

    -- if option is set, write the buffer and close it
    if opts.write_and_close then
        vim.cmd.write()
        if not state then
            vim.cmd.bd()
        end
    end

    -- fix import declarations -> remove import statements for classes in new folder and add import statements for classes in old folder
    if not is_package_rename then
        regex_fix_import_declaration.fix_import_declarations(old_folder, new_folder, old_class_path, new_class_path, old_class_name)
    end

    -- search occurences of the old class name
    local occurences = ripgrep.searchRegex(old_class_name)

    for _, file in ipairs(occurences) do
        local state = buffer.open(file)

        -- replace import and symbol usages of the old class name
        regex_import_declaration.replace_import_declaration(old_class_path, new_class_path)
        regex_symbol_usage.replace_symbol_usage(old_class_name, new_class_name)

        if opts.write_and_close then
            vim.cmd.write()
            if not state then
                vim.cmd.bd()
            end
        end
    end

    buffer.open(new_name)
end

-- setup the java rename plugin with options, see README.md for further information
function java_rename.setup(opts)
    rename_options.setup(opts)

    local opts = rename_options.get_rename_options()

    if not opts.enable then
        return
    end

    if opts.nvimtree then
        require("simaxme-java.rename.nvim-tree").setup({})
    end
end


return java_rename

