local java = {}

local rename = require("java.rename")
local snippets = require("java.snippets")

function java.setup(opts)
    if opts == nil then
        opts = {}
    end
    
    rename.setup(opts.rename)
    snippets.setup(opts.snippets)
end

return java
