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
            a = { "<cmd>Lspsaga code_action<cr>", "code action" },
            d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "definition" },
            f = { "<cmd>lua vim.lsp.buf.format()<cr>", "format" },
            h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "definition" },
            r = { "<cmd>Lspsaga rename<cr>", "rename" },
            u = { "<cmd>lua vim.lsp.buf.references()<cr>", "references" },
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

    function exit_visual_mode()
        local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'x', false)
    end

    --- @param lines string[]
    --- @return number
    local function get_indent(lines)
        local indent = 1 -- lua is one-indexed
        local indent_chars = { [" "] = true, ["\t"] = true }
        for char_idx = 1, #lines[1] do
            for _, line in ipairs(lines) do
                if #line > 0 then -- only check on non-empty lines
                    local char = lines[1]:sub(char_idx, char_idx)
                    if indent_chars[char] == nil then return indent end
                end
            end
            indent = indent + 1
        end
    end

    local vmappings = {
        y = {
            name = "yank",
            y = {
                function()
                    local v_start = vim.fn.getpos("v")[2]
                    local v_end = vim.fn.getpos(".")[2]
                    local selection = vim.api.nvim_buf_get_lines(0, math.min(v_start, v_end) - 1, math.max(v_start, v_end), true)

                    local indent = get_indent(selection)
                    for i, line in ipairs(selection) do
                        selection[i] = line:sub(indent)
                    end

                    local text = table.concat(selection, "\n")
                    vim.fn.setreg('+', text)
                    exit_visual_mode()
                end, "yank without indent"
            }
        },
    }

    -- Register the mappings for each mode
    plugin.register(mappings, opts)
    plugin.register(vmappings, vopts)
end

setup()
