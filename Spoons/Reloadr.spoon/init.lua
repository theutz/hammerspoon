---@class Reloadr
local obj = {}

obj.name = "Reloadr"
obj.license = "MIT"
obj.version = "0.0.0"
obj.author = "Michael Utz <michael.utz>"
obj.homepage = "https://theutz.com"

obj.watch_paths = {
	hs.configdir,
}

---@private
obj.watchers = {}

---@private
obj.logger = hs.logger.new(obj.name)

---@private
obj.notifications = {
	reloading = hs.notify.new({
		title = obj.name,
		informativeText = "Config reloading...",
		autoWithdraw = false,
		withdrawAfter = 0,
	}) --[[@as hs.notify]],
	reloaded = hs.notify.new({
		title = obj.name,
		informativeText = "Config reloaded!",
		autoWithdraw = true,
	}) --[[@as hs.notify]],
}

---@return self
---@nodiscard
function obj:init()
	return self
end

---@return self
---@nodiscard
function obj:start()
	self.notifications.reloading:send()
	for _, dir in pairs(self.watch_paths) do
		local cb = hs.fnutils.partial(self.reload, self)
		self.watchers[dir] = hs.pathwatcher.new(dir, cb):start()
	end

	return self
end

---@return self
---@nodiscard
function obj:stop()
	for _, dir in pairs(self.watch_paths) do
		---@diagnostic disable-next-line: param-type-mismatch
		self.logger.df("stopping pathwatcher: %s", dir)

		self.watchers[dir]:stop()
	end

	---@diagnostic disable-next-line: redundant-parameter
	local loaded_spoons = hs.spoons.list(true) --[[@as table]]

	---@diagnostic disable-next-line: param-type-mismatch
	self.logger.df("loaded spoons: %s", hs.inspect(loaded_spoons))

	local stoppable_spoons = hs.fnutils.filter(loaded_spoons, function(spoon)
		return type(spoon.stop) == "function"
	end) --[[@as table]]

	---@diagnostic disable-next-line: param-type-mismatch
	self.logger.df("stoppable spoons: %s", hs.inspect(stoppable_spoons))

	for _, spoon in ipairs(stoppable_spoons) do
		---@diagnostic disable-next-line: param-type-mismatch
		self.logger.df("stopping spoon: %s", spoon.name)

		spoon:stop()
	end

	return self
end

function obj:notifyReloaded()
	self.notifications.reloading:withdraw()
	self.notifications.reloaded:send()
end

---@private
---@param files string[]
function obj:reload(files)
	if self.allFilesAreGitFiles(files) then
		return
	else
		self:stop()
		hs.notify.withdrawAll()
		hs.reload()
	end
end

---@private
---@param files string[]
---@return boolean
---@nodiscard
function obj.allFilesAreGitFiles(files)
	return hs.fnutils.every(files, function(file)
		return string.match(file, hs.configdir .. "/.git")
	end)
end

return obj
