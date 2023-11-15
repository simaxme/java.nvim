local nvimTreeIntegration = {}

-- initialise nvim tree integration
-- will automaticly subscribe to the NodeRenamed event and execute the on_rename_file method
function nvimTreeIntegration.setup()
    local java_rename = require("java.rename")
    local utils = require("java.rename.utils")

    local status, api = pcall(require, "nvim-tree.api")

    if not status then
        return
    end


    api.events.subscribe(api.events.Event.NodeRenamed, function(data)
        local regex = "%.java$"

        local is_java_file = string.find(data.old_name, regex) ~= nil and string.find(data.new_name, regex) ~= nil

        if not is_java_file then
            return
        end

        local old_name = data.old_name
        local new_name = utils.realpath(data.new_name)

        local is_dir = utils.is_dir(new_name)

        if not is_dir then
            java_rename.on_rename_file(old_name, new_name)
        else
            local files = utils.list_folder_contents_recursive(new_name)

            for i, file in ipairs(files) do
                local old_file = old_name .. "/" .. file
                local new_file = new_name .. "/" .. file

                java_rename.on_rename_file(old_file, new_file)
            end
        end
    end)


end

return nvimTreeIntegration
