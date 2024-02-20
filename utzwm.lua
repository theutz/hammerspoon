local M = {}

-- local log = require "log"
-- local wf = hs.window.filter

M.mods = { "ctrl", "alt", "cmd" }

M.gridSize = hs.geometry.size(12, 12) or {}
M.gridMargin = hs.geometry.size(16, 16) or {}

M.definitions = {
	{ "c", { "1,1 10x10", "2,1 8x10", "3,1 6x10", "2,2 8x8", "3,2 6x8" } },
	{ "h", { "0,0 9x12", "0,0 6x12", "0,0 3x12" } },
	{ "i", { "6,0 6x6", "8,0 4x6", "10,0 2x6" } },
	{ "j", { "0,6 12x6", "1,6 10x6", "2,6 8x6", "3,6 6x6", "4,6 4x6" } },
	{ "k", { "0,0 12x6", "1,0 10x6", "2,0 8x6", "3,0 6x6", "4,0 4x6" } },
	{ "l", { "3,0 9x12", "6,0 6x12", "9,0 3x12" } },
	{ "m", { "6,6 6x6", "8,6 4x6", "10,6 2x6" } },
	{ "n", { "0,6 6x6", "0,6 4x6", "0,6 2x6" } },
	{ "return", { "0,0 12x12", "1,0 10x12", "2,0 8x12", "3,0 6x12", "4,0 4x12" } },
	{ "u", { "0,0 6x6", "0,0 4x6", "0,0 2x6" } },
}

function M.setup(mods)
	M.mods = mods
	hs.grid.setGrid(M.gridSize).setMargins(M.gridMargin)
	M.bindDefinitions()
	M.bindCenterOnScreen()
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
