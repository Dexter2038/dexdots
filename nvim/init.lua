-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.rustaceanvim = {
  server = {
    settings = {
      ["rust-analyzer"] = {
        procMacro = {
          enable = true,
        },
      },
    },
  },
}

require("transparent").clear_prefix("BufferLine")
require("transparent").clear_prefix("NeoTree")
require("transparent").clear_prefix("lualine")
require("transparent").clear_prefix("snacks")
require("transparent").clear_prefix("telescope")
require("transparent").clear_prefix("lazy")
