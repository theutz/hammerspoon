local M = {}

M.mods = { "ctrl", "alt", "cmd" }

M.gridSize = hs.geometry.size(12, 12) or {}
M.gridMargin = hs.geometry.size(16, 16) or {}

M.definitions = {
	{ "h", { "0,0 9x12", "0,0 6x12", "0,0 3x12" } },
	{ "i", { "6,0 6x6", "8,0 4x6", "10,0 2x6" } },
	{ "j", { "0,6 12x6", "4,6 4x6" } },
	{ "k", { "0,0 12x6", "4,0 4x6" } },
	{ "l", { "3,0 9x12", "6,0 6x12", "9,0 3x12" } },
	{ "m", { "6,6 6x6", "8,6 4x6", "10,6 2x6" } },
	{ "n", { "0,6 6x6", "0,6 4x6", "0,6 2x6" } },
	{ "o", { "1,1 10x10", "2,2 8x8", "3,3 6x6", "4,4 3x3" } },
	{ "return", { "0,0 12x12" } },
	{ "u", { "0,0 6x6", "0,0 4x6", "0,0 2x6" } },
}

function M.setup(mods)
	M.mods = mods
	hs.grid.setGrid(M.gridSize).setMargins(M.gridMargin)
	M.bindDefinitions()
	M.bindCenterOnScreen()
	hs.hotkey.bind(mods, "p", M.maximizeAllWindows)
end

function M.maximizeAllWindows()
	local apps = hs.application.runningApplications()
	for _, app in ipairs(apps) do
		local windows = app:visibleWindows()
		if windows then
			for _, window in ipairs(windows) do
				hs.grid.set(window, "0,0 12x12")
			end
		end
	end
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

function M.bindCenterOnScreen()
	hs.hotkey.bind(M.mods, "space", function()
		local win = hs.window.frontmostWindow()
		---@type table
		local frame = win:centerOnScreen():frame()
		frame.y = frame.y - (M.gridMargin.h / 2)
		win:move(frame)
	end)
end

return M
