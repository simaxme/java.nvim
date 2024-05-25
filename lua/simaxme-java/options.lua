local java_options = {}

local options = nil

function java_options.setup(opts)
    if opts == nil then
        opts = {}
    end

    if opts.root_markers == nil then
        opts.root_markers = {
          "main/java/",
          "test/java/"
        }
    end

    options = opts
end

function java_options.get_java_options()
    return options
end

return java_options
