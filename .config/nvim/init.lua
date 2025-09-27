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
