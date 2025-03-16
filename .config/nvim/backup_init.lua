vim.cmd("call plug#begin()")
vim.cmd([[Plug 'catppuccin/nvim', { 'as': 'catppuccin' }]])
vim.cmd([[Plug 'vim-airline/vim-airline']])
vim.cmd([[Plug 'neovim/nvim-lspconfig']])
vim.cmd([[Plug 'hrsh7th/nvim-cmp']])
vim.cmd([[Plug 'hrsh7th/cmp-nvim-lsp']])
vim.cmd([[Plug 'saadparwaiz1/cmp_luasnip']])
vim.cmd([[Plug 'hrsh7th/cmp-buffer']])
vim.cmd([[Plug 'hrsh7th/cmp-path']])
vim.cmd([[Plug 'hrsh7th/cmp-cmdline']])
vim.cmd([[Plug 'L3MON4D3/LuaSnip']])
vim.cmd([[Plug 'williamboman/mason.nvim']])
vim.cmd([[Plug 'williamboman/mason-lspconfig.nvim']])
vim.cmd([[Plug 'ellisonleao/gruvbox.nvim']])
vim.cmd([[Plug 'folke/tokyonight.nvim']])
vim.cmd([[Plug 'sainnhe/sonokai']])
-- vim.cmd([[Plug 'github/copilot.vim']])
vim.cmd([[Plug 'rafamadriz/friendly-snippets']])
vim.cmd([[Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}]])
vim.cmd([[Plug 'nvim-lua/plenary.nvim']])
vim.cmd([[Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }]])
vim.cmd("call plug#end()")

-- config update with the help of kickstart.nvim

-- make line numbers default
vim.opt.number = true
-- dont show mode, already in statusline
vim.opt.showmode = false
-- clipboard sync nvim and os
vim.opt.clipboard = 'unnamedplus'
-- enable break indent
vim.opt.breakindent = true
-- save undo file history
vim.opt.undofile = true
-- case-insensitive searching unless \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
-- configure how new splits will be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- preview substitution suggestions
vim.opt.inccommand = 'split'
-- show which line the cursor is on
vim.opt.cursorline = true
-- min number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10
-- keep highlight on search and clear it when pressing <Esc> in n mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")
-- enable mouse
vim.opt.mouse = "a"
-- theme settings
vim.o.background = "dark"
vim.cmd([[colorscheme sonokai]])
--vim.cmd([[colorscheme tokyonight]])
-- vim.cmd([[colorscheme catppuccin-macchiato]])
vim.g.airline_theme = "catppuccin"
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.api.nvim_set_keymap("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-g>", ":Telescope live_grep<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>cd", [[:cd %:p:h<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap(
    "n",
    "<leader>td",
    [[:edit ~\Documents\Usaneers_docs\References\todo.md<CR>]],
    { noremap = true, silent = true }
)

-- Enable bracket pairs
vim.api.nvim_set_keymap("i", "(", "()<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", "{", "{}<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", "[", "[]<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", '"', '""<Left>', { noremap = true })
vim.api.nvim_set_keymap("i", "'", "''<Left>", { noremap = true })

-- highlight text on yanking
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

require("mason").setup()
require("mason-lspconfig").setup()

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { "csharp_ls", "lua_ls", "clangd", "denols" }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        -- on_attach = my_custom_on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" }, -- Add 'vim' to the list of recognized globals
                },
            },
        },
    })
end

-- luasnip setup
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load({
    paths = { "C:\\Users\\daniel.zappala\\AppData\\Roaming\\Code\\User\\snippets" },
})

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- up
        ["<C-d>"] = cmp.mapping.scroll_docs(4), -- down
        ["<C-Space>"] = cmp.mapping.complete(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
    },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = "buffer" },
    }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

-- Set up rg as the default grepprg
vim.api.nvim_exec(
    [[
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
]],
    false
)

require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c_sharp", "lua", "cpp" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,
        --
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        additional_vim_regex_highlighting = false,
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})
