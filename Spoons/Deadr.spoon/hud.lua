---@class Hud
local M = {}

---@private
M.logger = hs.logger.new("hud")

---@private
M.canvas = hs.canvas.new(hs.screen.primaryScreen():frame()) --[[@as hs.canvas]]

---@alias hud.cells { [string]: { [1]: string[], [2]: string } }[]
---@private
M.items = {}

---@param o self
---@return self
function M:new(o)
	o = o or {}
	setmetatable(o, self)

	---@private
	self.__index = self

	return o
end

function M:show()
	self:renderCanvas()
	self.canvas:show()

	---@diagnostic disable param-type-mismatch
	self.logger.d("hud shown")
	self.logger.vf("hud elements: %s", hs.inspect(self.canvas:canvasElements()))
	---@diagnostic enable

	return self
end

function M:hide()
	self.canvas:hide()

	---@diagnostic disable-next-line: param-type-mismatch
	self.logger.d("hud hidden")

	return self
end

function M:isShowing()
	return self.canvas:isShowing()
end

---@public
---@param items hud.cells
function M:setItems(items)
	---@diagnostic disable param-type-mismatch
	self.logger.d("setting cells")
	self.logger.vf(hs.inspect(items))
	---@diagnostic enable

	self.items = items

	return self
end

function M:renderCanvas()
	local screenFrame = hs.screen.mainScreen():fullFrame()

	local canvas = hs.canvas.new(screenFrame)--[[@as hs.canvas]]

	canvas[1] = {
		type = "rectangle",
		action = "fill",
		fillColor = { hex = "#000", alpha = 0.3 },
	}

	canvas[2] = {
		type = "rectangle",
		action = "fill",
		fillColor = { hex = "#33a", alpha = 0.8 },
		frame = { x = 0, y = 0, w = 1200, h = 800 },
		roundedRectRadii = { xRadius = 16, yRadius = 16 },
	}

	canvas[2].frame.x = (screenFrame.w - canvas[2].frame.w) / 2
	canvas[2].frame.y = (screenFrame.h - canvas[2].frame.h) / 2

	local container = hs.geometry.new(canvas[2].frame)
	local size = 120
	local padding = 20
	local gap = padding / 2
	local max_cols = 9
	local row = 1
	local col = 1

	for i, item in ipairs(self.items) do
		local curr = canvas:elementCount()
		canvas[curr + 1] = {
			type = "rectangle",
			fillColor = { hex = "#000" },
			frame = {
				x = container.x
					+ padding
					+ (col - 1) * size
					+ (gap * (col - 1)),
				y = container.y
					+ padding
					+ (row - 1) * size
					+ (gap * (row - 1)),
				w = size,
				h = size,
			},
			roundedRectRadii = { xRadius = 8, yRadius = 8 },
		}

		if i % max_cols == 0 then
			row = row + 1
			col = 1
		else
			col = col + 1
		end
	end

	self.canvas = canvas
end

return M
