local log = require("log")
local wf = hs.window.filter

local mods = { "ctrl", "alt", "cmd" }

spoon.SpoonInstall:andUse("WindowScreenLeftAndRight", {
	hotkeys = {
		screen_left = { mods, "[" },
		screen_right = { mods, "]" },
	},
})

local gridSize = hs.geometry.size(12, 12) or {}
local gridMargin = hs.geometry.size(16, 16) or {}

hs.grid.setGrid(gridSize).setMargins(gridMargin)

local definitions = {
	{ "c", { "1,1 10x8", "2,2 8x6" } },
	{ "h", { "0,0 6x12", "0,0 9x12", "0,0 3x12" } },
	{ "i", { "6,0 6x6" } },
	{ "j", { "0,6 12x6", "0,6 6x6", "6,6 6x6", "0,6 4x6", "4,6 4x6", "8,6 4x6" } },
	{ "k", { "0,0 12x6", "0,0 6x6", "6,0 6x6", "0,0 4x6", "4,0 4x6", "8,0 4x6" } },
	{ "l", { "6,0 6x12", "3,0 9x12", "9,0 3x12" } },
	{ "m", { "6,6 6x6" } },
	{ "n", { "0,6 6x6" } },
	{ "return", { "0,0 12x12" } },
	{ "u", { "0,0 6x6" } },
}

for _, definition in ipairs(definitions) do
	local key, dimensions = table.unpack(definition)

	hs.hotkey.bind(mods, key, function()
		local win = hs.window.frontmostWindow()
		local current_grid = hs.grid.get(win)

		local grids = {}

		for _, dimension in ipairs(dimensions) do
			table.insert(grids, hs.geometry:new(dimension))
		end

		local new_grid = grids[1]

		for index, grid in ipairs(grids) do
			if current_grid and current_grid:equals(grid) then
				new_grid = grids[index + 1] or grids[1]
			end
		end

		hs.grid.set(win, new_grid)
	end)
end

-- Activate grid chooser
hs.hotkey.bind(mods, "x", function()
	local grid = hs.grid.getGrid()
	hs.grid.setGrid("6x4")
	hs.grid.show(function()
		hs.grid.setGrid(grid)
	end)
end)

-- Center on Screen
hs.hotkey.bind(mods, "space", function()
	local win = hs.window.frontmostWindow()
	---@type table
	local frame = win:centerOnScreen():frame()
	frame.y = frame.y - (gridMargin.h / 2)
	win:move(frame)
end)
