local rename_options = {}

local options

function rename_options.setup(opts)
    if opts == nil then
        opts = {
            nvimtree = true,
            write_and_close = false
        }
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
