local nvimTreeIntegration = {}

local utils = require("simaxme-java.rename.utils")
local options = require("simaxme-java.options")

-- initialise nvim tree integration
-- will automaticly subscribe to the NodeRenamed event and execute the on_rename_file method
function nvimTreeIntegration.setup(nvim_tree_options)
    local java_rename = require("simaxme-java.rename")
    local utils = require("simaxme-java.rename.utils")

    local status, api = pcall(require, "nvim-tree.api")

    if not status then
        return
    end


    api.events.subscribe(api.events.Event.NodeRenamed, function(data)
        local regex = "%.java$"

        local is_java_file = string.find(data.old_name, regex) ~= nil and string.find(data.new_name, regex) ~= nil

        if not is_java_file then
            local root_markers = options.get_java_options().root_markers

            -- find the relative root path by splitting the array, which is defined by options.root_markers
            local parts = utils.split_with_patterns(data.old_name, root_markers)

            -- if any of the root markers could not be found, cancel
            if #parts <= 1 then
                return nil
            end
        end

        local old_name = data.old_name
        local new_name = utils.realpath(data.new_name)

        java_rename.on_rename_file(old_name, new_name)

    end)

end

return nvimTreeIntegration
