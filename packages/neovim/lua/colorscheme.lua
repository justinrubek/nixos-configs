vim.g.sonokai_style = 'andromeda'
vim.g.sonokai_better_performance = 1
local status_ok, _ = pcall(vim.cmd, "colorscheme sonokai")
if not status_ok then
    vim.notify('Failed to load colorscheme sonokai', {timeout = 5000})
    return
end
