vim.opt.termguicolors = true
-- Подключение lazy.nvim
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

require("lazy").setup({
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
	-- feline.nvim for statusline
	{
		"feline-nvim/feline.nvim",
		config = function()
			require("feline").setup()
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false, -- Load this plugin during startup
		priority = 1000, -- Ensure it loads before other plugins
		opts = {
			style = "storm", -- Choose your preferred style: storm, night, moon, or day
		},
		-- catppuccin-mocha
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
		},
	},
	-- nvim-navic for code context in winbar
	{
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
		config = function()
			require("nvim-navic").setup()
		end,
	},
	-- Add vim-indent-object for indentation-based text objects
	{
		"michaeljsmith/vim-indent-object",
		-- This plugin is usually zero-config; it just works out of the box.
	},

	-- Add nvim-treesitter-textobjects for syntax-aware text objects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- automatically jump forward to text object
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
	-- alpha-nvim for a startup dashboard
	{
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},

	-- indent-blankline.nvim for indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup()
		end,
	},
	-- nvim-scrollbar for a scrollbar indicator
	{
		"petertriho/nvim-scrollbar",
		config = function()
			require("scrollbar").setup()
		end,
	},

	-- mini.animate for animations
	{
		"echasnovski/mini.animate",
		version = false,
		config = function()
			require("mini.animate").setup()
		end,
	},
	--{
	--"nvim-lualine/lualine.nvim",
	--dependencies = { "nvim-tree/nvim-web-devicons" },
	--config = function()
	--  require("lualine").setup({
	--    options = { theme = "gruvbox" }, -- Можно поменять тему
	--    component_separators = { left = "", right = "" },
	--    section_separators = { left = "", right = "" },
	--  })
	--end
	--},
	{
		"kdheepak/lazygit.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			vim.keymap.set("n", "<leader>g", ":LazyGit<CR>", { silent = true })
		end,
	},
	-- Debug Adapter Protocol (DAP) core
	{ "mfussenegger/nvim-dap" },

	-- nvim-dap-python for Python-specific debugging
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			-- This tells dap-python to use the Python interpreter from your virtual environment.
			-- Adjust the path if your venv folder is named differently.
			require("dap-python").setup(vim.fn.getcwd() .. "/venv/bin/python")
		end,
	},

	-- Optional: nvim-dap-ui for a nice debugging interface
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup()
			local dap = require("dap")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				require("dapui").open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				require("dapui").close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				require("dapui").close()
			end
		end,
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"ptdewey/pendulum-nvim",
		config = function()
			require("pendulum").setup({
				log_file = vim.fn.expand("$HOME/Documents/pendulum_log.csv"),
			})
		end,
	},
	{ "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" } },
	{
		"Exafunction/codeium.vim",
		config = function()
			vim.keymap.set("i", "<C-space>", function()
				return vim.fn["codeium#Accept"]()
			end, { noremap = true, expr = true, silent = true })
		end,
	},

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

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "python",
				highlight = { enable = true },
			})
		end,
	},

	{
		"morhetz/gruvbox",
		config = function()
			vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"terryma/vim-multiple-cursors",
		config = function()
			vim.cmd("nmap <C-d> <Plug>(MultipleCursorsDown)")
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- Python
					null_ls.builtins.formatting.black.with({ filetypes = { "python" } }),
					null_ls.builtins.diagnostics.ruff.with({ filetypes = { "python" } }),

					-- JavaScript and TypeScript
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
-- Назначение клавиш

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>f", ":Telescope live_grep<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { noremap = true, silent = true })

vim.keymap.set("v", "<leader>j", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>k", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>p", ":Pendulum<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>g", ":LazyGit<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>l", ":Lazy<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", ":!cargo build<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>r", ":!cargo run<CR>", { noremap = true, silent = true })

-- Create a custom command "KeybindingsHelp" that opens your cheat sheet
vim.api.nvim_create_user_command("KeybindingsHelp", function()
	-- Open the cheat sheet file in a horizontal split at the bottom
	vim.cmd("botright split ~/.config/nvim/keybindings.txt")
	-- Resize the window to half the current window height
	vim.cmd("resize " .. math.floor(vim.o.lines / 2))
	-- Set buffer options to mimic a help window
	vim.bo.buftype = "nofile" -- No file is associated
	vim.bo.bufhidden = "wipe" -- Wipe out when closed
	vim.bo.swapfile = false -- No swap file
	vim.bo.modifiable = false -- Read-only
end, {})

-- Map \h to open the keybindings cheat sheet in this help-like window
vim.keymap.set("n", "\\h", ":KeybindingsHelp<CR>", { desc = "Open keybindings cheat sheet" })

-- Управление дебаггером

vim.keymap.set("n", "<F9>", function()
	require("dapui").toggle()
end, { silent = true })
vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<F12>", function()
	require("dap").step_out()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bp", function()
	require("dap").toggle_breakpoint()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>a", ":Alpha<CR>", { noremap = true, silent = true })
-- General settings

-- Configure PATH and VIRTUAL_ENV

local venv_path = vim.fn.getcwd() .. "/venv"
if vim.fn.isdirectory(venv_path) == 1 then
	vim.env.VIRTUAL_ENV = venv_path
	vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
end

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
vim.cmd([[colorscheme catppuccin-mocha]])

-- Enable mouse support
vim.opt.mouse = "a"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Auto-save
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = "*",
	callback = function()
		vim.cmd("silent! write")
	end,
})

local function smart_dd()
	local line = vim.api.nvim_get_current_line()
	if line:match("^%s*$") then
		return '"_dd' -- delete without yanking if the line is empty
	else
		return "dd"
	end
end

-- Dd to copy only non-empty lines
vim.keymap.set("n", "dd", smart_dd, { expr = true, desc = "Smart dd: yank only non-empty lines" })

-- Copy file path with current line number
vim.keymap.set(
	"n",
	"<Leader>xc",
	":call setreg('+', expand('%:.') .. ':' .. line('.'))<CR>",
	{ desc = "Copy file path:line" }
)

-- Open the file from clipboard (which holds the path:line)
vim.keymap.set("n", "<Leader>xo", ":e <C-r>+<CR>", { desc = "Open file from clipboard" })

-- Open tmux pane in file's directory
vim.keymap.set(
	"n",
	"<Leader>tm",
	":let $VIM_DIR=expand('%:p:h')<CR>:silent !tmux split-window -hc $VIM_DIR<CR>",
	{ desc = "Open tmux pane in file's directory" }
)

-- Replace word under cursor
vim.keymap.set(
	"n",
	"<Leader>re",
	":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>",
	{ desc = "Replace word under cursor" }
)

-- Replace word under cursor in visual mode
vim.keymap.set(
	"v",
	"<Leader>re",
	":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>",
	{ desc = "Replace word under cursor" }
)

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

-- LSP settings
local lspconfig = require("lspconfig")
local navic = require("nvim-navic")

lspconfig.pyright.setup({
	on_attach = function(client, bufnr)
		navic.attach(client, bufnr)
	end,
	before_init = function(_, config)
		local path = vim.fn.getcwd() .. "/venv/bin/python"
		if vim.fn.filereadable(path) == 1 then
			config.settings.python.pythonPath = path
		end
	end,
	settings = {
		python = {
			formatting = {
				provider = "black", -- Указываем форматировщик, например, black
			},
		},
	},
})

lspconfig.rust_analyzer.setup({
	on_attach = function(client, bufnr)
		-- Disable formatting capability of rust_analyzer
		client.server_capabilities.documentFormattingProvider = false
		-- Your additional on_attach configurations
	end,
})

-- Completion settings
local cmp = require("cmp")
cmp.setup({
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
	},
})

-- Indent-blankline settings
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

-- Scrollbar settings
require("scrollbar").setup()

-- Mini.animate settings
require("mini.animate").setup()
