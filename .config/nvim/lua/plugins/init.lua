return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "python",
        "rust",
        "ron",
        "javascript",
        "gdscript",
      },
    },
  },
  -- Indentation Objects: vim-indent-object
  { "michaeljsmith/vim-indent-object" },

  -- Treesitter Text Objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter.configs").setup {
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
      }
    end,
  },

  -- Multiple Cursors: vim-multiple-cursors
  {
    "terryma/vim-multiple-cursors",
    config = function()
      vim.cmd "nmap <C-d> <Plug>(MultipleCursorsDown)"
    end,
  },

  -- Git Interface: lazygit.nvim

  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Animations: mini.animate
  {
    "echasnovski/mini.animate",
    version = "*",
    event = "VeryLazy", -- Ensures it loads after UI is ready
    config = function()
      require("mini.animate").setup()
    end,
  },

  -- Debug Adapter Protocol (DAP) Core
  { "mfussenegger/nvim-dap" },

  -- Python Debugging: nvim-dap-python
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup()
    end,
  },

  -- DAP UI: nvim-dap-ui
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
      local dap = require "dap"
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

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- Pendulum Logging: pendulum-nvim
  {
    "ptdewey/pendulum-nvim",
    event = "VeryLazy",
    config = function()
      require("pendulum").setup { log_file = vim.fn.expand "$HOME/Documents/pendulum_log.csv" }
    end,
  },

  -- Codeium: Code completion assistant
  {
    "Exafunction/codeium.vim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("i", "Tab", function()
        return vim.fn["codeium#Accept"]()
      end, { noremap = true, expr = true, silent = true })
    end,
  },

  -- Github Copilot: Code completion assistant
  -- {
  --   "github/copilot.vim",
  --   lazy = false, -- чтобы плагин загружался сразу
  -- },

  -- Rust crates dependencies aknowledge
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
}
