local M = {}

local watchers = {} ---@type hs.application.watcher[]

function M.setup()
	---@alias handler fun(name:string, eventType: integer, app: hs.application): nil
	---@type handler[]
	local handlers = { M.wezterm }
	for _, handler in ipairs(handlers) do
		table.insert(watchers, hs.application.watcher.new(handler))
	end
	return M
end

function M.start()
	for _, watcher in ipairs(watchers) do
		watcher:start()
	end
	return M
end

---@type handler
function M.wezterm(name, eventType, app)
	if name == "wezterm-gui" and eventType == hs.application.watcher.launched then
		app:setFrontmost(true)
		hs.timer.waitUntil(function() return #app:allWindows() > 0 end, function()
			for _, win in ipairs(app:allWindows()) do
				hs.grid.set(win, "2,1 8x10")
			end
		end, 0.1)
	end
end

return M
