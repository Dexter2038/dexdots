local dap = require("dap")


dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb", -- adjust as needed
	name = "lldb",
}


local lldb = {
	name = "Launch lldb",
	type = "lldb", -- matches the adapter
	request = "launch", -- could also attach to a currently running process
	program = function()
		return vim.fn.input(
			"Path to executable: ",
			vim.fn.getcwd() .. "/",
			"file"
		)
	end,
	cwd = "${workspaceFolder}",
	stopOnEntry = false,
	args = {},
	runInTerminal = false,
}


dap.configurations.rust = {
	lldb -- different debuggers or more configurations can be used here
}

local file = {
  name = "Launch file",
  type = "python",
  request = "launch",
  program = "${file}"
}


dap.configurations.python = {
  file
}
