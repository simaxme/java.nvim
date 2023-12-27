local java = {}

local options = require("java.options")
local rename = require("java.rename")
local snippets = require("java.snippets")

function java.setup(opts)
    if opts == nil then
        opts = {}
    end

    
    options.setup(opts)
    rename.setup(opts.rename)
    snippets.setup(opts.snippets)
end

return java
