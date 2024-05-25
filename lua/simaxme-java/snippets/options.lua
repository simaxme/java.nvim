local snippets_options = {}

local options

--- setup the snippet options
-- @param opts the options
function snippets_options.setup(opts)
    if opts == nil then
        opts = {
            enable = true
        }
    end

    if opts.enable == nil then
        opts.enable = true
    end

    options = opts

end

function snippets_options.get_snippets_options()
    return options
end

return snippets_options
