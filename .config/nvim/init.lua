vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

local opt = vim.opt
opt.number = true
opt.showmode = false
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.inccommand = 'split'
opt.cursorline = true
opt.scrolloff = 10
opt.hlsearch = true
opt.mouse = "a"
opt.cmdheight = 1
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

vim.o.background = "dark"
vim.cmd.colorscheme("catppuccin-frappe")

local keymap = vim.keymap.set
keymap("n", "<ESC>", "<cmd>nohlsearch<CR>", { desc = "Clear highlight" })
keymap("n", "<C-p>", require('fzf-lua').files, { desc = "Fzf Files" })
keymap("n", "<C-g>", require('fzf-lua').live_grep, { desc = "Fzf Grep" })
keymap("n", "<leader>cd", "<cmd>cd %:p:h<CR>", { desc = "Change directory to current file" })

vim.diagnostic.config({
    virtual_text = { prefix = "💢", spacing = 2 },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "always" },
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { 'lua_ls', 'csharp_ls', 'vtsls', 'vue_ls', 'tailwindcss', 'jdtls' }
})

local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
    '/vue-language-server' .. '/node_modules/@vue/language-server'

local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
}

vim.lsp.config('vtsls', {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'denols' },
})


require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        cs = { "csharpier" },
    },
})

keymap("n", "<leader>f", function() require("conform").format({ lsp_fallback = true }) end, { desc = "Format Buffer" })

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})

require('ufo').setup({
    provider_selector = function() return { 'treesitter', 'indent' } end
})
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
keymap('n', 'zR', require('ufo').openAllFolds)
keymap('n', 'zM', require('ufo').closeAllFolds)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        local key = vim.keymap.set

        key("n", "gd", vim.lsp.buf.definition, opts)
        key("n", "gD", vim.lsp.buf.declaration, opts)
        key("n", "gi", vim.lsp.buf.implementation, opts)
        key("n", "gr", vim.lsp.buf.references, opts)
        key("n", "K", vim.lsp.buf.hover, opts)
        key("n", "<C-k>", vim.lsp.buf.signature_help, opts)

        key("n", "<space>rn", vim.lsp.buf.rename, opts)
        key({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        key("n", "<space>D", vim.lsp.buf.type_definition, opts)

        key("n", "<C-e>", vim.diagnostic.open_float, opts)
        key("n", "<space>ds", vim.diagnostic.open_float, opts)
    end,
})
