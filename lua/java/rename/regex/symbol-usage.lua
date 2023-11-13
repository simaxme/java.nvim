local symbol_usage = {}

local buffer = require("java.rename.buffer")

local function generate_regex(class_name)
    return string.format(
        "[%%s,;%%(}<]%s[%%s,;%%(}%%.>]",
        class_name
    )
end

function symbol_usage.replace_symbol_usage(old_class_name, new_class_name)
    local regex = generate_regex(old_class_name)

    local lines = buffer.read_buffer_lines()

    local index = 0

    while index ~= nil do
        local index_start, index_end = string.find(lines, regex, index)

        if index_start == nil or index_end == nil then
            break
        end

        lines = lines:sub(0, index_start) ..
            new_class_name ..
            lines:sub(index_end, #lines)

        index = index_end
    end

    buffer.write_buffer_lines(lines)

    
end

return symbol_usage
