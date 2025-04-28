local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    python = { "black" },
    rust = { "rustfmt" },
    javascript = { "prettier" },
    c = { "clang-format" },
    cpp = { "clang-format" },
  },

  format_on_save = {
     -- These options will be passed to conform.format()
     timeout_ms = 500,
     lsp_fallback = true,
   },
}

return options
