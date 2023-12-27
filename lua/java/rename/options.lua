local rename_options = {}

local options

-- setup the options for the rename functionality
function rename_options.setup(opts)
    if opts == nil then
        opts = {
            enable = true,
            nvimtree = true,
            write_and_close = false,
        }
    end

    if opts.enable == nil then
        opts.enable = true
    end

    if opts.nvimtree == nil then
        opts.nvimtree = true
    end

    if opts.write_and_close == nil then
        opts.write_and_close = false
    end


    options = opts
end

function rename_options.get_rename_options()
    return options
end

return rename_options
