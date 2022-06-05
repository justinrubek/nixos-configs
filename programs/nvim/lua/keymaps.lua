local keymap_modes = {
    normal = "n",
    insert = "i",
    visual = "v",
    visual_block = "x",
    command = "c",
}

local keymaps = {
    normal = {
        ["<S-l>"] = ":BufferLineCycleNext<CR>",
        ["<S-h>"] = ":BufferLineCyclePrev<CR>",
    },
    visual = {
        -- Indenting
        ["<"] = "<gv",
        [">"] = ">gv",
    },
    visual_block = {
        -- Move entire block
        ["K"] = ":move '<-2<CR>gv-gv",
        ["J"] = ":move '>+1<CR>gv-gv",
    },
}
-- Set autocomplete button (tab)
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    else
        return t "<S-Tab>"
    end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })

-- Iterate over modes and call vim.keymap.set to apply the keymaps
-- Check if the keymap is a table and split it into multiple keymaps
-- Keymaps may optionally also specify opts as a pair alongside the function
for mode, keymap in pairs(keymaps) do
    if type(keymap) == "table" then
        for key, val in pairs(keymap) do
            if  type(val) == "table" then
                vim.keymap.set(keymap_modes[mode], key, val[1], val[2])
            else
                vim.keymap.set(keymap_modes[mode], key, val)
            end
        end
    else
        vim.keymap.set(keymap_modes[mode], key, keymap)
    end
end
