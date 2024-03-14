local watcher = hs.application.watcher

local M = {}

local watchers = {} ---@type hs.application.watcher[]

function M.setup()
	---@alias handler fun(name:string, eventType: integer, app: hs.application): nil
	---@type handler[]
	local handlers = {
		M.frontAndCenterOnLaunch "wezterm-gui",
		M.frontAndCenterOnLaunch "Neovide",
	}

	for _, handler in ipairs(handlers) do
		table.insert(watchers, watcher.new(handler))
	end

	return M
end

function M.start()
	for _, w in ipairs(watchers) do
		w:start()
	end

	return M
end

---@param name string
---@return handler
function M.frontAndCenterOnLaunch(name)
	return function(_, eventType, app)
		if app and app:name() == name and eventType == watcher.launched then
			app:setFrontmost(true)
			hs.timer.waitUntil(function() return #app:allWindows() > 0 end, function()
				for _, win in ipairs(app:allWindows()) do
					hs.grid.set(win, "2,1 8x10")
				end
			end, 0.1)
		end
	end
end

return M
