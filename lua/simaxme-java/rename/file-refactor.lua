local file_refactor = {}

local buffer = require("simaxme-java.rename.buffer")
local options = require("simaxme-java.rename.options")
local utils = require("simaxme-java.rename.utils")

local changes = {}

local function read_buffer(bufnumber)
    local line_count = vim.api.nvim_buf_line_count(bufnumber)
    local lines = vim.api.nvim_buf_get_lines(bufnumber, 0, line_count, true)
    local line_result = ""

    for i, line in ipairs(lines) do
        
        line_result = line_result .. line

        if i < (#lines) then
            line_result = line_result .. "\n"
        end
    end
    
    return line_result
end

local function read_file(path)
    local file = io.open(path, "rb")
    local content = file:read("*a")
    file:close()
    return content
end


function file_refactor.get_file_content(path)
    path = utils.realpath(path)

    local content

    if changes[path] ~= nil then
        return changes[path].new_content
    end

    if vim.fn.bufexists(path) == 1 then
        local bufnumber = vim.fn.bufnr(path)

        if (vim.api.nvim_buf_is_loaded(bufnumber)) then
            content = read_buffer(bufnumber)
        else
            vim.api.nvim_buf_delete(bufnumber, {})
            content = read_file(path)
        end
    else
        content = read_file(path)
    end

    return content
end

function file_refactor.clear_rewrite_request()
    changes = {}
end

function file_refactor.add_rewrite_request(path, new_content)
    path = utils.realpath(path)

    if changes[path] ~= nil then
        changes[path].new_content = new_content
        return
    end

    local old_content = file_refactor.get_file_content(path)

    changes[path] = {
        old_content = old_content,
        new_content = new_content
    }
end

-- replace all lines in the current buffer with a specific regex
-- @param regex the regex to search for
-- @param dist the destination value to write
function file_refactor.replace_buffer(path, regex, dist)
    path = utils.realpath(path)

    local line_result = file_refactor.get_file_content(path)

    local result = line_result:gsub(regex, dist)

    file_refactor.add_rewrite_request(path, result)
end

local telescope = require("simaxme-java.rename.telescope")
function file_refactor.write_requests()
    local rename_options = options.get_rename_options()

    if not rename_options.telescope then
        for key, value in pairs(changes) do
            buffer.open(key)
            buffer.write_buffer_lines(value.new_content)
        end
    else
        telescope.open_window(changes)
    end
end


return file_refactor
