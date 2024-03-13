local M = {}

M.watch_paths = {
	hs.configdir,
}

M.watchers = {}

function M.setup() return M end

local function reload(files)
	local allGitFiles = hs.fnutils.every(files, function(file) return string.match(file, hs.configdir .. "/.git") end)
	if allGitFiles then
		print "reload skipped"
		return
	else
		hs.reload()
	end
end

function M:start()
	for _, dir in pairs(M.watch_paths) do
		self.watchers[dir] = hs.pathwatcher.new(dir, reload):start()
	end
	return M
end

function M:stop()
	for _, dir in pairs(M.watch_paths) do
		self.watchers[dir]:stop()
	end
	return M
end

return M
