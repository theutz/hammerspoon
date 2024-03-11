local M = {}

M.mods = { "ctrl", "alt", "cmd" }
M.gridSize = hs.geometry.size(12, 12) or {}
M.gridMargin = hs.geometry.size(16, 16) or {}
M.grid = hs.grid.setGrid(M.gridSize).setMargins(M.gridMargin)
M.ordered_windows = {}
M.current_window = {}

function M.setup()
	hs.window.animationDuration = 0
	hs.grid.setGrid(M.gridSize).setMargins(M.gridMargin)
	hs.grid.ui.textSize = 100

	for _, definition in ipairs(M.getBindings()) do
		M.bind(definition)
	end
	M.setupMover(hs.hotkey.modal.new(M.mods, "c"))
end

M.getBindings = function()
	return {
		{ "h", { "0,0 9x12", "0,0 6x12", "0,0 3x12" } },
		{ "i", { "6,0 6x6", "8,0 4x6", "10,0 2x6" } },
		{ "j", { "0,6 12x6", "4,6 4x6" } },
		{ "k", { "0,0 12x6", "4,0 4x6" } },
		{ "l", { "3,0 9x12", "6,0 6x12", "9,0 3x12" } },
		{ "m", { "6,6 6x6", "8,6 4x6", "10,6 2x6" } },
		{ "n", { "0,6 6x6", "0,6 4x6", "0,6 2x6" } },
		{ "return", { "0,0 12x12" } },
		{ "u", { "0,0 6x6", "0,0 4x6", "0,0 2x6" } },
		{ "e", M.autoTiler },
		{ "space", M.centerOnScreen },
		{ "o", M.maximizeAllWindows },
		{ "0", M.nextWindow },
		{ "9", M.previousWindow },
	}
end

function M.saveWindowOrder()
	M.ordered_windows = {}

	local activeScreen = hs.window.frontmostWindow():screen()
	for _, win in ipairs(hs.window.orderedWindows()) do
		if win:screen() == activeScreen then table.insert(M.ordered_windows, win) end
	end

	M.current_window = { win = hs.window.frontmostWindow() }

	for i, win in ipairs(M.ordered_windows) do
		if M.current_window.win == win then M.current_window.index = i end
	end
end

function M.nextWindow()
	if #M.ordered_windows == 0 then M.saveWindowOrder() end
	local next = {}
	if M.current_window.index >= #M.ordered_windows then
		next.index = 1
	else
		next.index = M.current_window.index + 1
	end
	next.win = M.ordered_windows[next.index]
	local success = pcall(next.win:focus())
	if success then
		M.current_window = next
	else
		M.saveWindowOrder()
	end
end

function M.previousWindow()
	if #M.ordered_windows == 0 then M.saveWindowOrder() end
	local prev = {}
	if M.current_window.index <= 1 then
		prev.index = #M.ordered_windows
	else
		prev.index = M.current_window.index - 1
	end
	prev.win = M.ordered_windows[prev.index]
	prev.win:focus()
	local success = pcall(prev.win:focus())
	if success then
		M.current_window = prev
	else
		M.saveWindowOrder()
	end
end

function M.maximizeAllWindows()
	for _, win in ipairs(hs.window.orderedWindows()) do
		M.withAxHotfix(function(w) hs.grid.maximizeWindow(w) end)(win)
	end
end

function M.autoTiler()
	M.saveWindowOrder()
	local rows = math.floor(math.sqrt(#M.ordered_windows))
	local columns = math.ceil(math.sqrt(#M.ordered_windows))
	if rows * columns < #M.ordered_windows then rows = rows + 1 end

	local i = 1
	for row = 1, rows do
		for column = 1, columns do
			local win = M.ordered_windows[i]
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

	local function withTimerReset(fn)
		return function(...)
			timer:stop()
			fn(...)
			timer:start()
		end
	end

	local function move(dir)
		return withTimerReset(function()
			M.withAxHotfix(function(win) hs.grid["pushWindow" .. dir](win) end)(hs.window.frontmostWindow())
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
