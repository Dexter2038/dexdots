require "nvchad.mappings"

-- add yours here
-- Smart "dd": Delete without yanking if the line is empty
local function smart_dd()
  local line = vim.api.nvim_get_current_line()
  return (line:match "^%s*$" and '"_dd') or "dd"
end

local function accept_codeium_completition()
  return vim.fn["codeium#Accept"]()
end

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- LazyGit commands
map("n", "<Leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit menu" })
map("n", "<Leader>gf", ":LazyGitFilter<CR>", { desc = "Open LazyGitCommits" })
map("n", "<Leader>gc", ":LazyGitFilterCurrentFile<CR>", { desc = "Open LazyGitCommits for current file" })

-- Debugger Keybindings
map("n", "<F9>", function()
  require("dapui").toggle()
end, { silent = true })
map("n", "<F5>", function()
  require("dap").continue()
end, { noremap = true, silent = true })
map("n", "<F10>", function()
  require("dap").step_over()
end, { noremap = true, silent = true })
map("n", "<F11>", function()
  require("dap").step_into()
end, { noremap = true, silent = true })
map("n", "<F12>", function()
  require("dap").step_out()
end, { noremap = true, silent = true })
map("n", "<leader>bp", function()
  require("dap").toggle_breakpoint()
end, { noremap = true, silent = true })

map("n", "dd", smart_dd, { expr = true, desc = "Smart dd: yank only non-empty lines" })

map("n", "<Leader>pp", ":Pendulum<CR>", { desc = "Show pendulum logs table" })

map("n", "F", function()
  vim.diagnostic.open_float(nil, { focus = true })
end, { desc = "Show diagnostic message" })

map("i", "<S-Tab>", accept_codeium_completition, { noremap = true, silent = true, expr = true })

-- Keybinding to open the diagnostics list
map("n", "<leader>fd", ":Telescope diagnostics<CR>", { noremap = true, silent = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
