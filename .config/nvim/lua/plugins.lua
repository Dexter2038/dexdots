-- Подключение lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      require("nvim-tree").setup({
        view = { width = 30, side = "left" },
        renderer = { 
            icons = { show = { file = true, folder = true, folder_arrow = true, git = true },
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
        }, },
        filters = { dotfiles = false, git_ignored = false, custom = { '^.git$', '^__pycache__$' } },
      })
    end
  },
  -- feline.nvim for statusline
  {
    "feline-nvim/feline.nvim",
    config = function()
      require('feline').setup()
    end
  },
  {
  "folke/tokyonight.nvim",
  lazy = false,    -- Load this plugin during startup
  priority = 1000, -- Ensure it loads before other plugins
  opts = {
    style = "night", -- Choose your preferred style: storm, night, moon, or day
  },
  },
  -- nvim-navic for code context in winbar
  {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    config = function()
      require("nvim-navic").setup()
    end
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
        require("nvim-treesitter.configs").setup {
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
        }
      end,
    },
  -- alpha-nvim for a startup dashboard
  {
    "goolord/alpha-nvim",
    config = function()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },

  -- indent-blankline.nvim for indent guides
  {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    require("ibl").setup()
  end
  },
  -- nvim-scrollbar for a scrollbar indicator
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end
  },

  -- mini.animate for animations
  {
    "echasnovski/mini.animate",
    version = false,
    config = function()
      require('mini.animate').setup()
    end
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
  end
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
  end
  },
  {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()
  end
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
  { "Exafunction/codeium.vim", config = function()
      vim.keymap.set("i", "<C-space>", function() return vim.fn["codeium#Accept"]() end, { noremap = true, expr = true, silent = true })
    end
  },

  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = function() require("mason").setup() end },
  { "williamboman/mason-lspconfig.nvim", config = function()
      require("mason-lspconfig").setup { ensure_installed = { "pyright" } }
    end
  },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = "python",
        highlight = { enable = true }
      }
    end
  },

  { "morhetz/gruvbox", config = function() vim.cmd("colorscheme gruvbox") end },
  { "terryma/vim-multiple-cursors", config = function()
      vim.cmd("nmap <C-d> <Plug>(MultipleCursorsDown)")
    end
  },

  { "jose-elias-alvarez/null-ls.nvim", config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.ruff,
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
      }
    end
  },

  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = function()
      require("telescope").setup {
        defaults = {
          prompt_prefix = "> ",
          selection_caret = "> ",
          file_ignore_patterns = { "node_modules" }
        }
      }
    end
  },
  { "nvim-lua/plenary.nvim" }
})

