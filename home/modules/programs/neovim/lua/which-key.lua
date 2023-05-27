local setup = function()
    local plugin = require("which-key")


    -- Keybindings on the leader key
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

    -- Mappings: object keys become labeled option prompts to run the given functions
    local mappings = {
        f = {
            ["f"] = { require("telescope.builtin").find_files, "find file" },
            ["s"] = { require("telescope.builtin").live_grep, "search" },
        },

        -- quick-binding for find_files
        ["F"] = { require("telescope.builtin").find_files, "find file" },

        b = {
            name = "buffers",
            f = { "<cmd>Telescope buffers<cr>", "find" },
        },
        g = {
            name = "git",
            o = { "<cmd>Telescope git_status<cr>", "find changed files" },
            b = { "<cmd>Telescope git_branches<cr>", "checkout branch" },
            c = { "<cmd>Telescope git_commits<cr>", "checkout commits" },
        },
        l = {
            name = "lsp",
            p = {
                name = "peek",
                d = { "", "TODO" },
            },
        },

        t = {
            name = "toggle",
            t = { "<cmd>NvimTreeToggle<cr>", "file tree" },
            e = { "<cmd>TroubleToggle<cr>", "trouble" },
        },

        c = {
            name = "code",
            a = {  "<cmd>Lspsaga code_action<cr>", "code_action" },
            f = { "<cmd>Lspsaga lsp_finder<cr>", "lsp_finder" },
        },
    }

    local vmappings = {
    }

    -- Register the mappings for each mode
    plugin.register(mappings, opts)
    plugin.register(vmappings, vopts)
end

setup()
