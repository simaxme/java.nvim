local telescope = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require("telescope.previewers")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local utils = require("simaxme-java.rename.utils")

local function write_changes(changes)
    for key, value in pairs(changes) do
        if vim.fn.bufexists(key) == 1 and vim.api.nvim_buf_is_loaded(vim.fn.bufnr(key)) then
            local bufnumber = vim.fn.bufnr(key)
            local line_count = vim.api.nvim_buf_line_count(bufnumber)
            vim.api.nvim_buf_set_lines(bufnumber, 0, line_count, true, utils.split(value.new_content, "\n"))

            vim.api.nvim_buf_call(bufnumber, function()
                vim.cmd('w')
            end)
        else
            local file = io.open(key, "w")
            file:write(value.new_content)
            file:close()
        end
    end
end

function telescope.open_window(changes)
    local picker_results = {
        "Accept changes [C-a]",
        "Discard changes [C-d]"
    }

    for key, _ in pairs(changes) do
        table.insert(picker_results, key)
    end

    if #picker_results == 0 then
        return
    end

    pickers.new({}, {
        prompt_title = "colors",
        finder = finders.new_table {
            results = picker_results
        },
        previewer = previewers.new_termopen_previewer({
            get_command = function(entry, status)
                local value = entry[1]

                if value == "Accept changes [C-a]" then
                    return { "echo", "Accept all recommended changes to the files listed down below." }
                elseif value == "Discard changes [C-d]" then
                    return { "echo", "Discard all recommended changes to the files listed down below." }
                end

                local data = changes[value]

                local filename = vim.fn.tempname()
                local file = io.open(filename, "w")
                file:write(data.new_content .. "\n")
                file:close()

                return { "delta", value, filename }
            end
        }),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                -- actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                -- print(vim.inspect(selection))
                local value = selection[1]

                if value == "Accept changes [C-a]" then
                    write_changes(changes)
                    actions.close(prompt_bufnr)
                    return
                elseif value == "Discard changes [C-d]" then
                    actions.close(prompt_bufnr)
                    return
                end

                vim.notify("FILE " .. value)
                -- vim.api.nvim_put({ selection[1] }, "", false, true)
            end)

            return true
        end
    }):find()
end

return telescope
