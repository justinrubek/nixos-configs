-- Configure language servers
local lsp_defaults = {
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(client, bufnr)
        vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
    end
}

local lspconfig = require('lspconfig');
lspconfig.util.default_config = vim.tbl_deep_extend(
    'force',
    lspconfig.util.default_config,
    lsp_defaults
)
require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})
local servers = { 'pylsp', 'rust_analyzer', 'tsserver' }
for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = function(client, bufnr)
            lspconfig.util.default_config.on_attach(client, bufnr)
        end
    }
end

local luasnip = require('luasnip')
local cmp = require('cmp')
local lspkind = require('lspkind')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


-- Autocompletion
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        -- { name = 'copilot', keyword_length = 3 },
        { name = 'nvim_lsp', keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'treesitter', keyword_length = 2 },
    }, {
        { name = 'path' },
        { name = 'buffer', keyword_length = 3 },
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = { 
        fields = {'menu', 'abbr', 'kind' },
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            preset = "codicons",
            maxwidth = 50,
            before = function(entry, vim_item)
                return vim_item
            end,
        })
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        -- Move to next item in menu, insert a tab, or trigger completion menu
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        -- Move to the previous item in completion menu
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
})

