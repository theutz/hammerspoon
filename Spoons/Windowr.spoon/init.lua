---@class Windowr
local obj = {}

---@public
obj.name = "Windowr"

---@public
obj.author = "Michael Utz <michael@theutz.com>"

---@public
obj.version = "0.0.0"

---@public
obj.license = "MIT"

---@public
obj.homepage = "https://theutz.com"

---@private
obj.logger = hs.logger.new(obj.name)

---@private
obj.mods = { "ctrl", "alt", "cmd" }

---@private
obj.gridSize = hs.geometry.size(12, 12) or {}

---@private
obj.gridMargin = hs.geometry.size(16, 16) or {}

---@private
obj.grid = hs.grid.setGrid(obj.gridSize).setMargins(obj.gridMargin)

---@private
obj.tiles = {}

---@private
obj.current_tile = 1

---@public
obj.defaultHotkeys = {
	prevScreen = "[",
	nextScreen = "]",
	prevWindow = "9",
	nextWindow = "0",
	maximizeAllWindows = "o",
	centerOnScreen = "space",
	maxWidth = "x",
	maxHeight = "y",
	moveToLeft = "h",
	moveToBottom = "j",
	moveToTop = "k",
	moveToRight = "l",
	autoTiler = "e",
	fullscreen = "return",
	centralize = "c",
	northwest = "u",
	northeast = "i",
	southwest = "n",
	southeast = "m",
}

obj.sizes = {
	moveToLeft = { "0,0 8x12", "0,0 6x12", "0,0 4x12" },
	moveToRight = { "4,0 8x12", "6,0 6x12", "8,0 4x12" },
	moveToTop = { "0,0 12x6", "4,0 4x6" },
	moveToBottom = { "0,6 12x6", "4,6 4x6" },
	fullscreen = { "0,0 12x12" },
	centralize = { "1,1 10x10", "2,2 8x8", "3,3 6x6", "4,4 4x4", "0,0 12x12" },
	northwest = { "0,0 6x6", "0,0 4x6", "0,0 2x6" },
	northeast = { "6,0 6x6", "8,0 4x6", "10,0 2x6" },
	southwest = { "0,6 6x6", "0,6 4x6", "0,6 2x6" },
	southeast = { "6,6 6x6", "8,6 4x6", "10,6 2x6" },
}

function obj:init()
	hs.window.animationDuration = 0
	hs.grid.setGrid(self.gridSize).setMargins(self.gridMargin)
	hs.grid.ui.textSize = 20
end

function obj:bindHotkeys(map)
	local def = {}

	-- Create functions for the grid cyclers
	for name, _ in pairs(self.sizes) do
		self[name] = function()
			self:cycleThroughGrids(self.sizes[name])
		end
	end

	for name, key in pairs(map) do
		map[name] = { self.mods, key }
		def[name] = hs.fnutils.partial(self[name], self)
	end

	hs.spoons.bindHotkeysToSpec(def, map)
end

---@param sizes string[]
function obj:cycleThroughGrids(sizes)
	local win = hs.window.frontmostWindow()
	local current_grid = hs.grid.get(win)

	local grids = {}

	for _, dimension in ipairs(sizes) do
		table.insert(grids, hs.geometry:new(dimension))
	end

	local new_grid = grids[1]

	for index, grid in ipairs(grids) do
		if current_grid and current_grid:equals(grid) then
			new_grid = grids[index + 1] or grids[1]
		end
	end

	self:withAxHotfix(function(w)
		hs.grid.set(w, new_grid)
	end)(win)
end

function obj:maxWidth()
	self:withAxHotfix(function(win)
		local winGrid = hs.grid.get(win)
		assert(winGrid)

		local screenGrid = hs.grid.getGrid(win:screen())
		assert(screenGrid)

		winGrid.x = 0
		winGrid.w = screenGrid.w

		hs.grid.set(win, winGrid)
	end)(hs.window.frontmostWindow())
end

function obj:maxHeight()
	self:withAxHotfix(function(win)
		local winGrid = hs.grid.get(win)
		assert(winGrid)

		local screenGrid = hs.grid.getGrid(win:screen())
		assert(screenGrid)

		winGrid.y = 0
		winGrid.h = screenGrid.h

		hs.grid.set(win, winGrid)
	end)(hs.window.frontmostWindow())
end

function obj:saveWindowOrder()
	self.tiles = {}
	local win = hs.window.frontmostWindow()

	local activeScreen = win:screen()
	for i, w in ipairs(hs.window.orderedWindows()) do
		if w:screen() == activeScreen then
			table.insert(self.tiles, w)
			if win == w then
				self.current_tile = i
			end
		end
	end
end

function obj:getCurrentTile()
	return self.tiles[self.current_tile]
end

function obj:nextWindow()
	local index
	if self.current_tile >= #self.tiles then
		index = 1
	else
		index = self.current_tile + 1
	end
	local win = self.tiles[index]
	if win == nil then
		self:saveWindowOrder()
		return self:nextWindow()
	end
	win:focus()
	self.current_tile = index
end

function obj:prevWindow()
	local index
	if self.current_tile <= 1 then
		index = #self.tiles
	else
		index = self.current_tile - 1
	end
	local win = self.tiles[index]
	if win == nil then
		self:saveWindowOrder()
		return self:prevWindow()
	end
	win:focus()
	self.current_tile = index
end

function obj:maximizeAllWindows()
	for _, win in ipairs(hs.window.orderedWindows()) do
		if win:screen() == hs.window.frontmostWindow():screen() then
			self:withAxHotfix(function(w)
				hs.grid.maximizeWindow(w)
			end)(win)
		end
	end
end

function obj:autoTiler()
	self:saveWindowOrder()
	local rows = math.floor(math.sqrt(#self.tiles))
	local columns = math.ceil(math.sqrt(#self.tiles))
	if rows * columns < #self.tiles then
		rows = rows + 1
	end

	local i = 1
	for row = 1, rows do
		for column = 1, columns do
			local win = self.tiles[i]
			if win ~= nil then
				local cell =
					hs.geometry.new({ h = 12 / rows, w = 12 / columns })
				cell.x = (column - 1) * cell.w
				cell.y = (row - 1) * cell.h
				self:withAxHotfix(function()
					win:move(hs.grid.getCell(cell, win:screen()))
					hs.grid.snap(win)
				end)(win)
			end
			i = i + 1
		end
	end
end

function obj:centerOnScreen()
	local win = hs.window.frontmostWindow()
	self:withAxHotfix(function(w)
		w:centerOnScreen(nil, true)
		hs.grid.snap(w)
	end)(win)
end

function obj:nextScreen()
	local win = hs.window.frontmostWindow()
	self:withAxHotfix(function(w)
		local grid = hs.grid.get(w)
		local noResize = true
		local ensureInScreenBounds = false
		w:moveOneScreenEast(noResize, ensureInScreenBounds)
		hs.grid.set(w, grid)
	end)(win)
end

function obj:prevScreen()
	local win = hs.window.frontmostWindow()
	self:withAxHotfix(function(w)
		local grid = hs.grid.get(w)
		local noResize = true
		local ensureInScreenBounds = false
		w:moveOneScreenWest(noResize, ensureInScreenBounds)
		hs.grid.set(w, grid)
	end)(win)
end

function obj.axHotfix(win)
	if not win then
		win = hs.window.frontmostWindow()
	end

	local axApp = hs.axuielement.applicationElement(win:application()) or {}
	local wasEnhanced = axApp.AXEnhancedUserInterface
	if wasEnhanced then
		axApp.AXEnhancedUserInterface = false
	end

	return function()
		if wasEnhanced then
			axApp.AXEnhancedUserInterface = true
		end
	end
end

function obj:withAxHotfix(fn, position)
	if not position then
		position = 1
	end
	return function(...)
		local args = { ... }
		local revert = self.axHotfix(args[position])
		fn(...)
		revert()
	end
end

return obj
