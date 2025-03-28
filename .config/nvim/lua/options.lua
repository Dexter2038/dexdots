require "nvchad.options"

-- add yours here!

-- Python virtual environment configuration
local venv_path = vim.fn.getcwd() .. "/venv"
if vim.fn.isdirectory(venv_path) == 1 then
  vim.env.VIRTUAL_ENV = venv_path
  vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
end

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
