function exit_visual_mode()
    local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "x", false)
end

function copy_and_exit(text)
    vim.fn.setreg("+", text)
    exit_visual_mode()
end

--- @param lines string[]
--- @return number
local function get_indent(lines)
    local indent = 1 -- lua is one-indexed
    local indent_chars = {[" "] = true, ["\t"] = true}
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

function get_visual_selection()
    local v_start = vim.fn.getpos("v")[2]
    local v_end = vim.fn.getpos(".")[2]
    local selection = vim.api.nvim_buf_get_lines(0,
                                                 math.min(v_start, v_end) - 1,
                                                 math.max(v_start, v_end), true)
    return selection
end

function selection_without_indent()
    local selection = get_visual_selection()

    local indent = get_indent(selection)
    for i, line in ipairs(selection) do selection[i] = line:sub(indent) end

    return table.concat(selection, "\n")
end

function ghlink_lines()
    local v_start = vim.fn.getpos("v")[2]
    local v_end = vim.fn.getpos(".")[2]
    local file_path = vim.fn.expand("%:p")
    local result = vim.fn.system({
        "ghlink", "-l1", v_start, "-l2", v_end, file_path
    })
    copy_and_exit(result)
end

function ghlink_search()
    local selection = get_visual_selection()
    local text = table.concat(selection, "\n")
    local file_path = vim.fn.expand("%:p")
    local result = vim.fn.system({"ghlink", "-s", "-", file_path}, text)
    copy_and_exit(result)
end

function visual_yank_without_indent() copy_and_exit(selection_without_indent()) end
