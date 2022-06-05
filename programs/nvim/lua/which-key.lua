local setup = function()
    local plugin = require("which-key")

    local opts = {
        mode = "n",
        prefix = "<leader>",
        buffer = nil;
        silent = true,
        noremap = true,
        nowait = true,
    }

    local vopts = {
        mode = "v",
        prefix = "<leader>",
        buffer = nil;
        silent = true,
        noremap = true,
        nowait = true,
    }

    local mappings = {
        ["f"] = { require("telescope.builtin").find_files, "find file" },
    }

    local vmappings = {
    }

    plugin.register(mappings, opts)
    plugin.register(vmappings, vopts)
end

setup()
