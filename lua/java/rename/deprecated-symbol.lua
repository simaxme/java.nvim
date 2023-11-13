-- old utility class for lsp focus, not needed anymore

local symbol = {}

local utils = require("java.rename.utils")
local buffer = require("java.rename.buffer")

-- focus the class symbol in the current java buffer
function symbol.focus_class(class_name)
    -- local class_name = vim.fn.expand("%:t:r")

    local line_result = buffer.read_buffer_lines()

    print("Searching for class name: ".. class_name)


    local regex = string.format(
        "class(%%s+)%s(%%s*){",
        class_name
    )

    local start_index, end_index = string.find(line_result, regex)

    if start_index == nil then
        local regex = string.format(
            "interface(%%s+)%s(%%s*){",
            class_name
        )

        start_index, end_index = string.find(line_result, regex)
    end

    if start_index == nil then
        local regex = string.format(
            "enum(%%s+)%s(%%s*){",
            class_name
        )

        start_index, end_index = string.find(line_result, regex)
    end

    if start_index == nil then
        return
    end

    local sub = string.sub(line_result, start_index, end_index)

    local index = string.find(sub, class_name)

    local dist_index = start_index + index - 1;

    local arr = utils.split(string.sub(line_result, 0, dist_index), "\n")
    local result_line = #arr
    local result_col = #(arr[#arr]) - 1

    vim.api.nvim_win_set_cursor(0, {result_line, result_col})
end

function symbol.rename_java_class(old_name, name)
    symbol.focus_class(old_name)
    vim.lsp.buf.rename(name)
end

return symbol
