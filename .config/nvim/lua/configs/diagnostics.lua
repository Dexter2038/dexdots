-- custom/configs/diagnostics.lua
local M = {}

M.setup = function()
  -- Disable inline virtual text diagnostics
  vim.diagnostic.config({
    virtual_text = false,   -- No inline clutter!
    signs = true,           -- But still show signs in the gutter
    underline = true,       -- Underline problematic code (if you like that)
    update_in_insert = false, -- Wait until you exit insert mode to update diagnostics
    severity_sort = true,   -- Sort diagnostics by severity
  })

  -- Set a shorter updatetime so the hover appears quickly
  vim.o.updatetime = 250

  -- Automatically open a floating window with diagnostics on CursorHold
  vim.cmd [[
    autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus = false })
  ]]
end

return M

