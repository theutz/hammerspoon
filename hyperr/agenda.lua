return function()
	local workingDir = os.getenv "HOME" .. "/code/theutz/agenda"
	local cmd = { "start", "--", "/opt/homebrew/bin/nvim", workingDir .. "/today.md" }
	local task = hs.task.new("/opt/homebrew/bin/wezterm", nil, cmd)
	task:setWorkingDirectory(workingDir)
	task:start()
end
