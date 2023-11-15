local class_declaration = {}

local buffer = require("java.rename.buffer")

-- will look for the class declaration in the renamed java file and rename the class name
function class_declaration.replace_class_declaration(old_class_name, new_class_name)
    local line_result = buffer.read_buffer_lines()

    local regex = string.format(
        "class(%%s+)%s(%%s*){",
        old_class_name
    )

    local start_index, end_index = string.find(line_result, regex)

    if start_index == nil then
        local regex = string.format(
            "interface(%%s+)%s(%%s*){",
            old_class_name
        )

        start_index, end_index = string.find(line_result, regex)
    end

    if start_index == nil then
        local regex = string.format(
            "enum(%%s+)%s(%%s*){",
            old_class_name
        )

        start_index, end_index = string.find(line_result, regex)
    end

    if start_index == nil then
        print("NOTHING FOUND")
        return
    end

    local sub = string.sub(line_result, start_index, end_index)

    local index = string.find(sub, old_class_name)

    local dist_index = start_index + index - 1;

    local result = string.sub(line_result, 0, dist_index - 1) ..
        new_class_name ..
        string.sub(line_result, dist_index + #old_class_name, #line_result)

    buffer.write_buffer_lines(result)
end

return class_declaration
