local M = {}

M.mods = { "ctrl", "alt", "cmd" }

M.gridSize = hs.geometry.size(12, 12) or {}
M.gridMargin = hs.geometry.size(16, 16) or {}

M.grid = hs.grid.setGrid(M.gridSize).setMargins(M.gridMargin)

M.definitions = {
	{ "h", { "0,0 9x12", "0,0 6x12", "0,0 3x12" } },
	{ "i", { "6,0 6x6", "8,0 4x6", "10,0 2x6" } },
	{ "j", { "0,6 12x6", "4,6 4x6" } },
	{ "k", { "0,0 12x6", "4,0 4x6" } },
	{ "l", { "3,0 9x12", "6,0 6x12", "9,0 3x12" } },
	{ "m", { "6,6 6x6", "8,6 4x6", "10,6 2x6" } },
	{ "n", { "0,6 6x6", "0,6 4x6", "0,6 2x6" } },
	{ "return", { "0,0 12x12" } },
	{ "u", { "0,0 6x6", "0,0 4x6", "0,0 2x6" } },
}

function M.setup(mods)
	hs.window.animationDuration = 0
	M.mods = mods
	hs.grid.setGrid(M.gridSize).setMargins(M.gridMargin)

	for _, definition in ipairs(M.definitions) do
		M.bindDefinition(definition)
	end
	hs.hotkey.bind(mods, "e", M.autoTiler)
	hs.hotkey.bind(mods, "p", M.tidyUpWindows)
	hs.hotkey.bind(mods, "space", M.centerOnScreen)
	M.setupMover(hs.hotkey.modal.new(M.mods, "c"))
end

function M.autoTiler()
	local screen = hs.window.frontmostWindow():screen()
	local windows = {}
	for _, w in ipairs(hs.window.orderedWindows()) do
		if w:screen() == screen then table.insert(windows, w) end
	end
	local rows = math.floor(math.sqrt(#windows))
	local cols = math.ceil(math.sqrt(#windows))
	if rows * cols < #windows then rows = rows + 1 end

	local i = 1
	for r = 0, rows - 1 do
		for c = 0, cols - 1 do
			local win = windows[i]
			if win ~= nil then
				local h = 12 / rows
				local w = 12 / cols
				local cell = hs.geometry.new { x = c * w, y = r * h, h = h, w = h }
				M.withAxHotfix(function()
					win:move(hs.grid.getCell(cell, win:screen()))
					hs.grid.snap(win)
				end)(win)
			end
			i = i + 1
		end
	end
end

function M.tidyUpWindows()
	local wins = hs.window.orderedWindows()
	local count = 0
	local grid = M.gridSize
	grid.xy = "0,0"

	local shouldStop = function()
		count = count + 1
		return count > #wins
	end

	hs.timer.doUntil(shouldStop, function()
		local win = wins[count]
		M.withAxHotfix(function(w) hs.grid.snap(w) end)(win)
	end, 0.01)
end

function M.bindDefinitions() end

function M.bindDefinition(definition)
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

		M.withAxHotfix(function(w) hs.grid.set(w, new_grid) end)(win)
	end)
end

function M.centerOnScreen()
	local win = hs.window.frontmostWindow()
	M.withAxHotfix(function(w)
		w:centerOnScreen(nil, true)
		hs.grid.snap(w)
	end)(win)
end

function M.setupMover(modal)
	local timer

	function modal:entered() ---@diagnostic disable-line duplicate-set-field
		hs.alert.closeAll()
		hs.alert.show("WinMove", "forever")
		timer = hs.timer.doAfter(10, function() modal:exit() end)
	end

	function modal:exited() ---@diagnostic disable-line duplicate-set-field
		hs.alert.closeAll()
		timer:stop()
		timer = nil
	end

	local function move(dir)
		local fn = function()
			timer:stop()
			M.withAxHotfix(function(w) hs.grid["pushWindow" .. dir](w) end)(hs.window.frontmostWindow())
			timer:start()
		end
		return nil, fn, fn
	end

	local function resize(dir)
		local fn = function()
			timer:stop()
			M.withAxHotfix(function(w) hs.grid["resizeWindow" .. dir](w) end)(hs.window.frontmostWindow())
			timer:start()
		end
		return nil, fn, fn
	end

	modal:bind("", "escape", function() modal:exit() end)

	modal:bind("", "h", move "Left")
	modal:bind("", "j", move "Down")
	modal:bind("", "k", move "Up")
	modal:bind("", "l", move "Right")
	modal:bind("", "f", resize "Taller")
	modal:bind("", "d", resize "Shorter")
	modal:bind("", "s", resize "Thinner")
	modal:bind("", "g", resize "Wider")
end

function M.axHotfix(win)
	if not win then win = hs.window.frontmostWindow() end

	local axApp = hs.axuielement.applicationElement(win:application()) or {}
	local wasEnhanced = axApp.AXEnhancedUserInterface
	if wasEnhanced then axApp.AXEnhancedUserInterface = false end

	return function()
		if wasEnhanced then axApp.AXEnhancedUserInterface = true end
	end
end

function M.withAxHotfix(fn, position)
	if not position then position = 1 end
	return function(...)
		local args = { ... }
		local revert = M.axHotfix(args[position])
		fn(...)
		revert()
	end
end

return M
