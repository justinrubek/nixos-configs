local keymap_modes = {
    normal = "n",
    insert = "i",
    visual = "v",
    visual_block = "x",
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

-- Iterate over modes and call vim.keymap.set to apply the keymaps
-- Check if the keymap is a table and split it into multiple keymaps
for mode, keymap in pairs(keymaps) do
    if type(keymap) == "table" then
        for key, command in pairs(keymap) do
            vim.keymap.set(keymap_modes[mode], key, command, { noremap = true, silent = true })
        end
    else
        vim.keymap.set(keymap_modes[mode], keymap, { noremap = true, silent = true })
    end
end
