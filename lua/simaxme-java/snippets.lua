local snippets = {}

local snippets_options = require("simaxme-java.snippets.options")

--- setup snippets
-- @param opts the options for the snippets, see more at README.md
function snippets.setup(opts)
    snippets_options.setup(opts)

    local opts = snippets_options.get_snippets_options()

    if not opts.enable then
        return
    end

    local status, _ = pcall(require, "luasnip")

    if not status then
        return
    end

    require("simaxme-java.snippets.init-file").setup()
end

return snippets
