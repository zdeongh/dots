require("config.lazy")

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
vim.cmd([[colorscheme catppuccin-frappe]])
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.api.nvim_set_keymap("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-g>", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>cd", [[:cd %:p:h<CR>]], { noremap = true, silent = true })

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

vim.lsp.config.clangd = {
  cmd = { 'clangd', '--background-index' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp' },
}
vim.lsp.config.csharp_ls = {
  cmd = { 'csharp-ls' },
  root_markers = { 'project.json', '*.csproj', '*.sln' },
  filetypes = { 'cs' },
}
vim.lsp.enable({ 'csharp_ls', 'clangd' })

-- luasnip setup
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load({
    paths = { "-paste-vscode-snippet-path-here" },
})

-- Set up rg as the default grepprg
vim.api.nvim_exec(
    [[
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
]],
    false
)

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
