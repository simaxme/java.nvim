local java = {}

local rename = require("java.rename")

function java.setup(opts)
    if opts == nil then
        opts = {}
    end
    rename.setup(opts.rename)
end

return java
