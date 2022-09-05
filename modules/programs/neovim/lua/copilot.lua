vim.g.copilot_no_tab_map = true
vim.g.copilot_assumed_mapped = true
vim.g.copilot_tab_fallback = ""
vim.api.nvim_set_keymap("i", "<A-t>", 'copilot#Accept("")', { silent = true, expr = true })
