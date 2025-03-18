
-- Назначение клавиш

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>f', ':Telescope live_grep<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, { noremap = true, silent = true })

vim.keymap.set('v', '<leader>j', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<leader>k', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set('n', '<leader>p', ':Pendulum<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>g', ':LazyGit<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { noremap = true, silent = true })

-- Create a custom command "KeybindingsHelp" that opens your cheat sheet
vim.api.nvim_create_user_command("KeybindingsHelp", function()
  -- Open the cheat sheet file in a horizontal split at the bottom
  vim.cmd("botright split ~/.config/nvim/keybindings.txt")
  -- Resize the window to half the current window height
  vim.cmd("resize " .. math.floor(vim.o.lines / 2))
  -- Set buffer options to mimic a help window
  vim.bo.buftype = "nofile"    -- No file is associated
  vim.bo.bufhidden = "wipe"    -- Wipe out when closed
  vim.bo.swapfile = false      -- No swap file
  vim.bo.modifiable = false    -- Read-only
end, {})

-- Map \h to open the keybindings cheat sheet in this help-like window
vim.keymap.set("n", "\\h", ":KeybindingsHelp<CR>", { desc = "Open keybindings cheat sheet" })

-- Управление дебаггером

vim.keymap.set("n", "<F9>", function() require("dapui").toggle() end, { silent = true })
vim.keymap.set("n", "<F5>", function() require("dap").continue() end, { noremap = true, silent = true })
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, { noremap = true, silent = true })
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, { noremap = true, silent = true })
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bp", function() require("dap").toggle_breakpoint() end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>a', ':Alpha<CR>', { noremap = true, silent = true })
