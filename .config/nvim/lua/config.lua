
-- General settings

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tab and indentation settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Disable line wrapping
vim.opt.wrap = false

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Appearance
vim.opt.background = "dark"
vim.cmd([[colorscheme tokyonight]])

-- Enable mouse support
vim.opt.mouse = "a"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Auto-save
vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {
  pattern = "*",
  callback = function()
    vim.cmd("silent! write")
  end,
})

local function smart_dd()
  local line = vim.api.nvim_get_current_line()
  if line:match("^%s*$") then
    return '"_dd'  -- delete without yanking if the line is empty
  else
    return "dd"
  end
end

-- Dd to copy only non-empty lines
vim.keymap.set("n", "dd", smart_dd, { expr = true, desc = "Smart dd: yank only non-empty lines" })

-- Copy file path with current line number
vim.keymap.set("n", "<Leader>xc", ":call setreg('+', expand('%:.') .. ':' .. line('.'))<CR>", { desc = "Copy file path:line" })

-- Open the file from clipboard (which holds the path:line)
vim.keymap.set("n", "<Leader>xo", ":e <C-r>+<CR>", { desc = "Open file from clipboard" })

-- Open tmux pane in file's directory
vim.keymap.set("n", "<Leader>tm", ":let $VIM_DIR=expand('%:p:h')<CR>:silent !tmux split-window -hc $VIM_DIR<CR>", { desc = "Open tmux pane in file's directory" })

-- Replace word under cursor
vim.keymap.set("n", "<Leader>re", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>", { desc = "Replace word under cursor" })

-- Replace word under cursor in visual mode
vim.keymap.set("v", "<Leader>re", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>", { desc = "Replace word under cursor" })

-- Jump back in jump list
vim.keymap.set("n", "<BS>", "<C-o>", { desc = "Jump back in jump list" })

-- Yank whole buffer
vim.keymap.set("n", "<Leader>Y", ":%y+<CR>", { desc = "Yank whole buffer" })

-- Format buffer
vim.keymap.set("n", "<Leader>F", ":lua vim.lsp.buf.format()<CR>", { desc = "Format buffer" })

local cmds = { "nu!", "rnu!", "nonu!" }
local current_index = 1

function toggle_numbering()
  current_index = current_index % #cmds + 1
  vim.cmd("set " .. cmds[current_index])
  local signcol = cmds[current_index] == "nonu!" and "yes:4" or "auto"
  vim.opt.signcolumn = signcol
end

-- Toggle line numbering modes
vim.keymap.set("n", "<Leader>tn", toggle_numbering, { desc = "Toggle numbering modes" })

-- Repeat command on visual selection
vim.keymap.set("x", ".", ":norm .<CR>", { desc = "Repeat command on visual selection" })

-- Repeat macro on visual selection
vim.keymap.set("x", "@", ":norm @q<CR>", { desc = "Repeat macro on visual selection" })


function toggle_quickfix()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
    end
  end
  if qf_exists then
    vim.cmd("cclose")
  elseif not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd("copen")
  end
end

-- Toggle quickfix
vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Toggle quickfix window" })


-- Auto-format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- LSP settings
local lspconfig = require('lspconfig')
local navic = require("nvim-navic")

lspconfig.pyright.setup{
  on_attach = function(client, bufnr)
    navic.attach(client, bufnr)
  end,
  before_init = function(_, config)
    local path = vim.fn.getcwd() .. '/venv/bin/python'
    if vim.fn.filereadable(path) == 1 then
      config.settings.python.pythonPath = path
    end
  end
}

-- Completion settings
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }
})

-- Indent-blankline settings
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

-- Scrollbar settings
require("scrollbar").setup()

-- Mini.animate settings
require('mini.animate').setup()

