local M = {}

M.mods = { "ctrl", "alt", "cmd" }

M.gridSize = hs.geometry.size(12, 12) or {}
M.gridMargin = hs.geometry.size(16, 16) or {}

M.definitions = {
	{ "c", { "1,1 10x10", "2,2 8x8", "3,3 6x6", "4,4 3x3" } },
	{ "h", { "0,0 9x12", "0,0 6x12", "0,0 3x12" } },
	{ "i", { "6,0 6x6", "8,0 4x6", "10,0 2x6" } },
	{ "j", { "0,6 12x6", "4,6 4x6" } },
	{ "k", { "0,0 12x6", "4,0 4x6" } },
	{ "l", { "3,0 9x12", "6,0 6x12", "9,0 3x12" } },
	{ "m", { "6,6 6x6", "8,6 4x6", "10,6 2x6" } },
	{ "n", { "0,6 6x6", "0,6 4x6", "0,6 2x6" } },
	{ "return", { "0,0 12x12" } },
	{ "u", { "0,0 6x6", "0,0 4x6", "0,0 2x6" } },
	{ "w", { "1,0 10x12", "2,0 8x12", "3,0 6x12", "4,0 4x12" } },
}

function M.setup(mods)
	M.mods = mods
	hs.grid.setGrid(M.gridSize).setMargins(M.gridMargin)
	M.bindDefinitions()
	hs.hotkey.bind(mods, "p", M.maximizeAllWindows)
	hs.hotkey.bind(mods, "space", M.centerOnScreen)
end

function M.maximizeAllWindows()
	local wins = hs.window.visibleWindows()

	local count = 0
	local alert = nil
	local shouldStop = function() return count == #wins end
	hs.timer.doUntil(shouldStop, function(timer)
		hs.alert.closeSpecific(alert, 0)
		alert = hs.alert.show("Resizing " .. count .. " of " .. #wins, { fadeInDuration = 0, fadeOutDuration = 0 })
		count = count + 1
		local win = wins[count]
		hs.grid.set(win, "0,0 12x12")
		win:centerOnScreen(nil, true, 0)
		if shouldStop() then
			hs.alert.closeSpecific(alert, 0)
			timer:stop()
			timer = nil
			return
		end
	end, 0.1)
end

function M.bindDefinitions()
	for _, definition in ipairs(M.definitions) do
		local key, dimensions = table.unpack(definition)

		hs.hotkey.bind(M.mods, key, function()
			local win = hs.window.frontmostWindow()
			local current_grid = hs.grid.get(win)

			local grids = {}

			for _, dimension in ipairs(dimensions) do
				table.insert(grids, hs.geometry:new(dimension))
			end

			local new_grid = grids[1]

			for index, grid in ipairs(grids) do
				if current_grid and current_grid:equals(grid) then new_grid = grids[index + 1] or grids[1] end
			end

			hs.grid.set(win, new_grid)
		end)
	end
end

function M.centerOnScreen()
	local win = hs.window.frontmostWindow()
	win:centerOnScreen(nil, true)
end

return M
