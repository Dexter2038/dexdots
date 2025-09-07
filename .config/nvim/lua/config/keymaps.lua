-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Next buffer with Tab
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })

-- Previous buffer with Shift+Tab
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true })

-- ; to : in normal mode
vim.keymap.set("n", ";", ":", { noremap = true })
