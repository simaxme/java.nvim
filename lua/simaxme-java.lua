local java = {}

local options = require("simaxme-java.options")
local rename = require("simaxme-java.rename")
local snippets = require("simaxme-java.snippets")

function java.setup(opts)
    if opts == nil then
        opts = {}
    end

    
    options.setup(opts)
    rename.setup(opts.rename)
    snippets.setup(opts.snippets)
end

return java
