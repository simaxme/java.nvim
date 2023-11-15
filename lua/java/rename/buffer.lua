local buffer = {}

local utils = require("java.rename.utils")

-- will read all lines of the current buffer (seperated by \n)
function buffer.read_buffer_lines()
    local line_count = vim.api.nvim_buf_line_count(0)
    local lines = vim.api.nvim_buf_get_lines(0, 0, line_count, true)

    local line_result = ""

    for i, line in ipairs(lines) do
        
        line_result = line_result .. line

        if i < (#lines) then
            line_result = line_result .. "\n"
        end
    end

    return line_result
end

-- will write the given lines to the current buffer
-- @param data the lines to write, seperated by \n
function buffer.write_buffer_lines(data)
    local line_count = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_buf_set_lines(0, 0, line_count, true, utils.split(data, "\n"))
end

-- replace all lines in the current buffer with a specific regex
-- @param regex the regex to search for
-- @param dist the destination value to write
function buffer.replace_buffer(regex, dist)
    local line_result = buffer.read_buffer_lines()

    local result = line_result:gsub(regex, dist)

    buffer.write_buffer_lines(result)
end

-- will open a specific buffer by path
-- if the buffer already exists, it will focus it
-- @param the file path for the file to open
function buffer.open(name)
    if vim.fn.bufexists(name) == 1 then
        local bufnumber = vim.fn.bufnr(name)
        vim.cmd.buffer(bufnumber)
        return true
    end

    vim.cmd.edit(name)

    return false
end


return buffer
