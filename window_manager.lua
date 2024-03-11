local M = {}

M.mods = { "ctrl", "alt", "cmd" }
M.gridSize = hs.geometry.size(12, 12) or {}
M.gridMargin = hs.geometry.size(16, 16) or {}
M.grid = hs.grid.setGrid(M.gridSize).setMargins(M.gridMargin)
M.tiles = {}
M.current_tile = 1

function M.setup()
	hs.window.animationDuration = 0
	hs.grid.setGrid(M.gridSize).setMargins(M.gridMargin)
	hs.grid.ui.textSize = 20

	for _, definition in ipairs(M.getBindings()) do
		M.bind(definition)
	end
end

function M.bind(definition)
	local key, action = table.unpack(definition)
	local fn

	if type(action) == "function" then
		fn = action
	elseif type(action) == "table" then
		fn = function()
			local win = hs.window.frontmostWindow()
			local current_grid = hs.grid.get(win)

			local grids = {}

			for _, dimension in ipairs(action) do
				table.insert(grids, hs.geometry:new(dimension))
			end

			local new_grid = grids[1]

			for index, grid in ipairs(grids) do
				if current_grid and current_grid:equals(grid) then new_grid = grids[index + 1] or grids[1] end
			end

			M.withAxHotfix(function(w) hs.grid.set(w, new_grid) end)(win)
		end
	end

	hs.hotkey.bind(M.mods, key, fn)
end

M.getBindings = function()
	M.setupMover(hs.hotkey.modal.new(M.mods, ";"))
	return {
		{ "0", M.nextWindow },
		{ "9", M.previousWindow },
		{ "[", M.prevScreen },
		{ "]", M.nextScreen },
		{ "c", { "1,1 10x10", "2,2 8x8", "3,3 6x6", "4,4 4x4", "0,0 12x12" } },
		{ "e", M.autoTiler },
		{ "h", { "1,0 9x12", "0,0 6x12", "0,0 3x12" } },
		{ "i", { "6,0 6x6", "8,0 4x6", "10,0 2x6" } },
		{ "j", { "0,6 12x6", "4,6 4x6" } },
		{ "k", { "0,0 12x6", "4,0 4x6" } },
		{ "l", { "3,0 9x12", "6,0 6x12", "9,0 3x12" } },
		{ "m", { "6,6 6x6", "8,6 4x6", "10,6 2x6" } },
		{ "n", { "0,6 6x6", "0,6 4x6", "0,6 2x6" } },
		{ "o", M.maximizeAllWindows },
		{
			"r",
			function()
				M.saveWindowOrder()
				M.autoTiler()
			end,
		},
		{ "return", { "0,0 12x12" } },
		{ "space", M.centerOnScreen },
		{ "u", { "0,0 6x6", "0,0 4x6", "0,0 2x6" } },
		{ "x", M.maxWidth },
		{ "y", M.maxHeight },
	}
end

function M.maxWidth()
	M.withAxHotfix(function(win)
		local winGrid = hs.grid.get(win)
		assert(winGrid)
		local screenGrid = hs.grid.getGrid(win:screen())
		assert(screenGrid)

		winGrid.x = 0
		winGrid.w = screenGrid.w

		hs.grid.set(win, winGrid)
	end)(hs.window.frontmostWindow())
end

function M.maxHeight()
	M.withAxHotfix(function(win)
		local winGrid = hs.grid.get(win)
		assert(winGrid)
		local screenGrid = hs.grid.getGrid(win:screen())
		assert(screenGrid)

		winGrid.y = 0
		winGrid.h = screenGrid.h

		hs.grid.set(win, winGrid)
	end)(hs.window.frontmostWindow())
end

function M.saveWindowOrder()
	M.tiles = {}
	local win = hs.window.frontmostWindow()

	local activeScreen = win:screen()
	for i, w in ipairs(hs.window.orderedWindows()) do
		if w:screen() == activeScreen then
			table.insert(M.tiles, w)
			if win == w then M.current_tile = i end
		end
	end
end

function M.getCurrentTile() return M.tiles[M.current_tile] end

function M.nextWindow()
	local index
	if M.current_tile >= #M.tiles then
		index = 1
	else
		index = M.current_tile + 1
	end
	local win = M.tiles[index]
	if win == nil then
		M.saveWindowOrder()
		return M.nextWindow()
	end
	win:focus()
	M.current_tile = index
end

function M.previousWindow()
	local index
	if M.current_tile <= 1 then
		index = #M.tiles
	else
		index = M.current_tile - 1
	end
	local win = M.tiles[index]
	if win == nil then
		M.saveWindowOrder()
		return M.previousWindow()
	end
	win:focus()
	M.current_tile = index
end

function M.maximizeAllWindows()
	for _, win in ipairs(hs.window.orderedWindows()) do
		if win:screen() == hs.window.frontmostWindow():screen() then
			M.withAxHotfix(function(w) hs.grid.maximizeWindow(w) end)(win)
		end
	end
end

function M.autoTiler()
	local rows = math.floor(math.sqrt(#M.tiles))
	local columns = math.ceil(math.sqrt(#M.tiles))
	if rows * columns < #M.tiles then rows = rows + 1 end

	local i = 1
	for row = 1, rows do
		for column = 1, columns do
			local win = M.tiles[i]
			if win ~= nil then
				local cell = hs.geometry.new { h = 12 / rows, w = 12 / columns }
				cell.x = (column - 1) * cell.w
				cell.y = (row - 1) * cell.h
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

function M.centerOnScreen()
	local win = hs.window.frontmostWindow()
	M.withAxHotfix(function(w)
		w:centerOnScreen(nil, true)
		hs.grid.snap(w)
	end)(win)
end

function M.nextScreen()
	local win = hs.window.frontmostWindow()
	M.withAxHotfix(function(w)
		local grid = hs.grid.get(w)
		local noResize = true
		local ensureInScreenBounds = false
		w:moveOneScreenEast(noResize, ensureInScreenBounds)
		hs.grid.set(w, grid)
	end)(win)
end

function M.prevScreen()
	local win = hs.window.frontmostWindow()
	M.withAxHotfix(function(w)
		local grid = hs.grid.get(w)
		local noResize = true
		local ensureInScreenBounds = false
		w:moveOneScreenWest(noResize, ensureInScreenBounds)
		hs.grid.set(w, grid)
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

	local function withTimerReset(fn)
		return function(...)
			timer:stop()
			fn(...)
			timer:start()
		end
	end

	local function move(dir)
		return withTimerReset(function()
			M.withAxHotfix(function(win)
				local winGrid = hs.grid.get(win)
				assert(winGrid)
				local screen = win:screen()
				hs.grid["pushWindow" .. dir](win)
				if screen ~= win:screen() then
					local screenGrid = hs.grid.getGrid(win:screen())
					assert(screenGrid)
					if dir == "Left" then
						winGrid.x = screenGrid.w - winGrid.w
					elseif dir == "Right" then
						winGrid.x = 0
					end
					hs.grid.set(win, winGrid)
				end
			end)(hs.window.frontmostWindow())
		end)
	end

	local function resize(dir)
		return withTimerReset(function()
			M.withAxHotfix(function(win) hs.grid["resizeWindow" .. dir](win) end)(hs.window.frontmostWindow())
		end)
	end

	modal:bind("", "escape", function() modal:exit() end)
	local bindings = {
		{ "", "h", { move "Left" } },
		{ "", "j", { move "Down" } },
		{ "", "k", { move "Up" } },
		{ "", "l", { move "Right" } },
		{ "", "=", { resize "Taller", resize "Wider" } },
		{ "", "-", { resize "Shorter", resize "Thinner" } },
		{ "", "n", { M.nextWindow } },
		{ "", "p", { M.previousWindow } },
		{ "Shift", "h", { resize "Thinner" } },
		{ "Shift", "j", { resize "Taller" } },
		{ "Shift", "k", { resize "Shorter" } },
		{ "Shift", "l", { resize "Wider" } },
	}
	for _, binding in ipairs(bindings) do
		local mods, key, steps = table.unpack(binding)
		modal:bind(mods, key, function()
			for _, step in ipairs(steps) do
				step()
			end
		end)
	end
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
