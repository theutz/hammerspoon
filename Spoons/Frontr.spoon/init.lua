---@class Frontr
local obj = {}

obj.name = "Frontr"
obj.version = "0.0.0"
obj.license = "MIT"
obj.author = "Michael Utz <michael@theutz.com"
obj.homepage = "https://theutz.com"

---@private
obj.logger = hs.logger.new(obj.name)

---@private
obj.app_names = {} --[=[ @as string[] ]=]

---@private
obj.grid = "1,1 10x10"

---@private
---@type hs.application.watcher
obj.watcher = nil

---@public
---@return self
---@nodiscard
function obj:init()
	local cb = hs.fnutils.partial(self.handleApplicationEvent, self)
	self.watcher = hs.application.watcher.new(cb)
	return self
end

---@public
---@return self
---@nodiscard
function obj:start()
	---@diagnostic disable-next-line: param-type-mismatch
	self.logger.d("starting...")
	---@diagnostic disable-next-line: param-type-mismatch
	self.logger.df("app_names: %s", hs.inspect(self.app_names))

	self.watcher:start()

	return self
end

---@public
---@return self
---@nodiscard
function obj:stop()
	---@diagnostic disable-next-line: param-type-mismatch
	self.logger.d("stopping...")
	self.watcher:stop()
	return self
end

---@param name string
---@param eventType string
---@param app hs.application
function obj:handleApplicationEvent(name, eventType, app)
	---@diagnostic disable-next-line: param-type-mismatch
	obj.logger.vf("handling application event: %s", name)

	local is_watched = hs.fnutils.some(self.app_names, function(app_name)
		return app_name == name
	end)

	---@diagnostic disable-next-line: param-type-mismatch
	obj.logger.vf("%s is watched? %s", name, is_watched)

	local is_launched = eventType == hs.application.watcher.launched

	if is_watched and is_launched then
		if is_watched then
			---@diagnostic disable-next-line: param-type-mismatch
			self.logger.df("fronting %s", name)
		end

		app:setFrontmost(true)

		local thereAreWindows = function()
			return #app:allWindows() > 0
		end

		local makeThemBig = function()
			for _, win in ipairs(app:allWindows()) do
				---@diagnostic disable-next-line: param-type-mismatch
				self.logger.df("biggifying %s", win:title())
				hs.grid.set(win, self.grid)
			end
		end

		hs.timer.waitUntil(thereAreWindows, makeThemBig, 0.1)
	end
end

return obj
