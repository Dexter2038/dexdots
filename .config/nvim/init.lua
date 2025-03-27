------------------------------------------------
-- General Options & Environment Setup
------------------------------------------------
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.background = "dark"
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.bo.indentexpr = ""
	end,
})

-- Auto-save on changes and leaving insert mode
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = "*",
	callback = function()
		vim.cmd("silent! write")
	end,
})

-- Python virtual environment configuration
local venv_path = vim.fn.getcwd() .. "/venv"
if vim.fn.isdirectory(venv_path) == 1 then
	vim.env.VIRTUAL_ENV = venv_path
	vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
end

------------------------------------------------
-- Plugin Manager: lazy.nvim Setup
------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------
-- Plugin Setup via lazy.nvim
------------------------------------------------
require("lazy").setup({

	-- File Explorer: nvim-tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = { width = 30, side = "left" },
				renderer = {
					icons = {
						show = { file = true, folder = true, folder_arrow = true, git = true },
						glyphs = {
							default = "",
							symlink = "",
							folder = {
								arrow_closed = "",
								arrow_open = "",
								default = "",
								open = "",
							},
						},
					},
				},
				filters = { dotfiles = false, git_ignored = false, custom = { "^.git$", "^__pycache__$" } },
			})
		end,
	},

	-- Status Line: feline.nvim
	{
		"feline-nvim/feline.nvim",
		config = function()
			require("feline").setup()
		end,
	},

    -- NVChad
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end
    }

	-- Themes: tokyonight and catppuccin
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = { style = "storm" },
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
		},
	},

	-- Winbar Code Context: nvim-navic
	{
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
		config = function()
			require("nvim-navic").setup()
		end,
	},

	-- Indentation Objects: vim-indent-object
	{ "michaeljsmith/vim-indent-object" },

	-- Treesitter Text Objects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})
		end,
	},

	-- Startup Dashboard: alpha-nvim
	{
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},

	-- Indent Guides: indent-blankline.nvim
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup()
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})
		end,
	},

	-- Scrollbar Indicator: nvim-scrollbar
	{
		"petertriho/nvim-scrollbar",
		config = function()
			require("scrollbar").setup()
		end,
	},

	-- Animations: mini.animate
	{
		"echasnovski/mini.animate",
		version = false,
		config = function()
			require("mini.animate").setup()
		end,
	},

	-- Git Interface: lazygit.nvim
	{
		"kdheepak/lazygit.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			vim.keymap.set("n", "<leader>g", ":LazyGit<CR>", { silent = true })
		end,
	},

	-- Debug Adapter Protocol (DAP) Core
	{ "mfussenegger/nvim-dap" },

	-- Python Debugging: nvim-dap-python
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			require("dap-python").setup(vim.fn.getcwd() .. "/venv/bin/python")
		end,
	},

	-- DAP UI: nvim-dap-ui
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup()
			local dap = require("dap")
			-- Open DAP UI on initialization
			dap.listeners.after.event_initialized["dapui_config"] = function()
				require("dapui").open()
			end
			-- Close DAP UI on termination or exit
			dap.listeners.before.event_terminated["dapui_config"] = function()
				require("dapui").close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				require("dapui").close()
			end
		end,
	},

	-- Buffer Line: bufferline.nvim
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},

	-- Git Signs: gitsigns.nvim
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- Pendulum Logging: pendulum-nvim
	{
		"ptdewey/pendulum-nvim",
		config = function()
			require("pendulum").setup({ log_file = vim.fn.expand("$HOME/Documents/pendulum_log.csv") })
		end,
	},

	-- Completion Engine: nvim-cmp and sources
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" },
	},

	-- Codeium: Code completion assistant
	{
		"Exafunction/codeium.vim",
		config = function()
			vim.keymap.set("i", "<C-space>", function()
				return vim.fn["codeium#Accept"]()
			end, { noremap = true, expr = true, silent = true })
		end,
	},

	-- LSP Configurations and Management
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({ ensure_installed = { "pyright" } })
		end,
	},
	-- Mason Null LS integration
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = { "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim" },
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = { "ruff", "black", "eslint-lsp", "prettierd", "rustfmt", "stylua" },
				automatic_installation = true,
			})
		end,
	},

	-- Treesitter: Syntax highlighting, etc.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "python", "rust", "ron" },
				highlight = { enable = true },
			})
		end,
	},

	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup()
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false,
	},

	-- Gruvbox Theme
	--{
	--	"morhetz/gruvbox",
	--	config = function()
	--		vim.cmd("colorscheme gruvbox")
	--	end,
	--},

	-- Multiple Cursors: vim-multiple-cursors
	{
		"terryma/vim-multiple-cursors",
		config = function()
			vim.cmd("nmap <C-d> <Plug>(MultipleCursorsDown)")
		end,
	},

	-- Formatters & Linters Integration: null-ls.nvim
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- Python format and lint
					null_ls.builtins.formatting.black.with({ filetypes = { "python" } }),
					null_ls.builtins.diagnostics.ruff.with({ filetypes = { "python" } }),
					-- null_ls.builtins.diagnostics.gdtoolkit.with({ filetypes = { "gd" } }),
					-- null_ls.builting.formatting.gdtoolkit.with({ filetypes = { "gd" } }),
					null_ls.builtins.formatting.djlint.with({ filetypes = { "html" } }),
					-- JavaScript/TypeScript
					null_ls.builtins.formatting.prettierd.with({
						filetypes = { "javascript", "typescript", "css", "html", "json" },
					}),
					null_ls.builtins.diagnostics.eslint.with({
						filetypes = { "javascript", "typescript", "css", "html", "json" },
					}),
					-- Lua
					null_ls.builtins.formatting.stylua.with({ filetypes = { "lua" } }),
					-- Rust
					null_ls.builtins.formatting.rustfmt.with({ filetypes = { "rust", "rs", "toml", "yaml" } }),
					-- Uncomment below for rust_analyzer diagnostics:
					--null_ls.builtins.diagnostics.rust_analyzer.with({ filetypes = { "rust", "rs", "toml", "yaml" } }),
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ async = false })
							end,
						})
					end
				end,
			})
		end,
	},

	-- Telescope: Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					prompt_prefix = "> ",
					selection_caret = "> ",
					file_ignore_patterns = { "node_modules" },
				},
			})
		end,
	},
	{ "nvim-lua/plenary.nvim" },
})

------------------------------------------------
-- Keybindings
------------------------------------------------
local keymap = vim.keymap.set

-- File explorer toggle
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Telescope live grep
keymap("n", "<leader>f", ":Telescope live_grep<CR>", { noremap = true, silent = true })

-- Save file
keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })

-- LSP: go-to definition and hover
keymap("n", "<leader>d", vim.lsp.buf.definition, { noremap = true, silent = true })
keymap("n", "<leader>h", vim.lsp.buf.hover, { noremap = true, silent = true })

-- Move lines in visual mode
keymap("v", "<leader>j", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap("v", "<leader>k", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Open Pendulum log
keymap("n", "<leader>p", ":Pendulum<CR>", { noremap = true, silent = true })

-- Reload lazy plugins
keymap("n", "<leader>l", ":Lazy<CR>", { noremap = true, silent = true })

-- Cargo commands for Rust projects
keymap("n", "<leader>b", ":!cargo build<CR>", { noremap = true, silent = true })
keymap("n", "<leader>r", ":!cargo run<CR>", { noremap = true, silent = true })

-- Keybindings Cheat Sheet Command and Shortcut
vim.api.nvim_create_user_command("KeybindingsHelp", function()
	vim.cmd("botright split ~/.config/nvim/keybindings.txt")
	vim.cmd("resize " .. math.floor(vim.o.lines / 2))
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.modifiable = false
end, {})
keymap("n", "\\h", ":KeybindingsHelp<CR>", { desc = "Open keybindings cheat sheet" })

-- Debugger Keybindings
keymap("n", "<F9>", function()
	require("dapui").toggle()
end, { silent = true })
keymap("n", "<F5>", function()
	require("dap").continue()
end, { noremap = true, silent = true })
keymap("n", "<F10>", function()
	require("dap").step_over()
end, { noremap = true, silent = true })
keymap("n", "<F11>", function()
	require("dap").step_into()
end, { noremap = true, silent = true })
keymap("n", "<F12>", function()
	require("dap").step_out()
end, { noremap = true, silent = true })
keymap("n", "<leader>bp", function()
	require("dap").toggle_breakpoint()
end, { noremap = true, silent = true })
keymap("n", "<leader>a", ":Alpha<CR>", { noremap = true, silent = true })

------------------------------------------------
-- Custom Functions & Additional Keybindings
------------------------------------------------
-- Smart "dd": Delete without yanking if the line is empty
local function smart_dd()
	local line = vim.api.nvim_get_current_line()
	return (line:match("^%s*$") and '"_dd') or "dd"
end
keymap("n", "dd", smart_dd, { expr = true, desc = "Smart dd: yank only non-empty lines" })

-- Copy file path with current line number to clipboard
keymap("n", "<Leader>xc", ":call setreg('+', expand('%:.') .. ':' .. line('.'))<CR>", { desc = "Copy file path:line" })

-- Open file from clipboard (expects path:line format)
keymap("n", "<Leader>xo", ":e <C-r>+<CR>", { desc = "Open file from clipboard" })

-- Open tmux pane in current file's directory
keymap(
	"n",
	"<Leader>tm",
	":let $VIM_DIR=expand('%:p:h')<CR>:silent !tmux split-window -hc $VIM_DIR<CR>",
	{ desc = "Open tmux pane in file's directory" }
)

-- Replace word under cursor in both normal and visual modes
keymap(
	"n",
	"<Leader>re",
	":%%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>",
	{ desc = "Replace word under cursor" }
)
keymap(
	"v",
	"<Leader>re",
	":%%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>",
	{ desc = "Replace word under cursor" }
)

-- Jump back in jump list
keymap("n", "<BS>", "<C-o>", { desc = "Jump back in jump list" })

-- Yank entire buffer to clipboard
keymap("n", "<Leader>Y", ":%y+<CR>", { desc = "Yank whole buffer" })

-- Format buffer via LSP
keymap("n", "<Leader>F", ":lua vim.lsp.buf.format()<CR>", { desc = "Format buffer" })

-- Toggle line numbering modes (absolute, relative, none)
local numbering_cmds = { "nu!", "rnu!", "nonu!" }
local current_num = 1
function toggle_numbering()
	current_num = current_num % #numbering_cmds + 1
	vim.cmd("set " .. numbering_cmds[current_num])
	vim.opt.signcolumn = (numbering_cmds[current_num] == "nonu!" and "yes:4") or "auto"
end
keymap("n", "<Leader>tn", toggle_numbering, { desc = "Toggle numbering modes" })

-- Repeat command and macro on visual selection
keymap("x", ".", ":norm .<CR>", { desc = "Repeat command on visual selection" })
keymap("x", "@", ":norm @q<CR>", { desc = "Repeat macro on visual selection" })

-- Toggle quickfix window
local function toggle_quickfix()
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
keymap("n", "<leader>q", toggle_quickfix, { desc = "Toggle quickfix window" })

------------------------------------------------
-- LSP Setup
------------------------------------------------
local lspconfig = require("lspconfig")
local navic = require("nvim-navic")

-- Python LSP: Pyright
lspconfig.pyright.setup({
	on_attach = function(client, bufnr)
		navic.attach(client, bufnr)
	end,
	before_init = function(_, config)
		local py_path = vim.fn.getcwd() .. "/venv/bin/python"
		if vim.fn.filereadable(py_path) == 1 then
			config.settings.python.pythonPath = py_path
		end
	end,
	settings = {
		python = {
			formatting = { provider = "black" },
		},
	},
})

-- Rust LSP: rust_analyzer
--lspconfig.rust_analyzer.setup({
--	on_attach = function(client, bufnr)
--		client.server_capabilities.documentFormattingProvider = true
--	end,
--	settings = {
--		["rust-analyzer"] = {
--			inlayHints = {
--				enable = true, -- Enable inlay hints for types and other information
--			},
--			completion = {
--				autoimport = { enable = true }, -- Enable automatic imports in completions
--			},
--			assist = { importGranularity = "module", importPrefix = "by_self" },
--			cargo = { loadOutDirsFromCheck = true },
--			procMacro = { enable = true },
--		},
--	},
--})

------------------------------------------------
-- Completion (nvim-cmp) Setup
------------------------------------------------
local cmp = require("cmp")
cmp.setup({
	completion = {
		autocomplete = { cmp.TriggerEvent.TextChanged },
	},
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- Use your snippet engine (e.g., vsnip)
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "vsnip" },
	},
})

------------------------------------------------
-- Additional UI Enhancements
------------------------------------------------
-- Whitespace and end-of-line indicators
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

-- Reinitialize scrollbar and animations (if needed)
require("scrollbar").setup()
require("mini.animate").setup()

-- themes
require("catppuccin").setup({
	flavour = "macchiato", -- latte, frappe, macchiato, mocha
	integrations = {
		nvimtree = true,
		telescope = true,
		treesitter = true,
	},
})
vim.cmd("colorscheme catppuccin")
