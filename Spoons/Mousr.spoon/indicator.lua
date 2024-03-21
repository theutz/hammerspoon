---@class (exact) Indicator
---@field logger hs.logger
---@field canvases hs.canvas[]
---@field makeElements fun(self: self, frame: hs.geometry): hs.canvas[]
---@field margin integer
---@field show fun(self: self): nil
---@field hide fun(self: self): nil
---@field new fun(self: self, o: table?): self
---@field __index self
local M = {}

---@private
M.canvases = {}

---@private
M.margin = 16

---@public
---@nodiscard
function M:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.logger.i "indicator loaded"
	return o
end

---@public
function M:show()
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("margin: %d", self.margin)

	local screens = hs.screen.allScreens() --[=[@as hs.screen[]]=]

	for i, screen in ipairs(screens) do
		self.canvases[i] = hs
			.canvas
			.new(screen:fullFrame()) --[[@as hs.canvas]]
			:appendElements(self:makeElements(screen:frame())) --[[@as hs.canvas]]
			:behavior { "canJoinAllSpaces", "stationary" }
	end

	for _, canvas in ipairs(self.canvases) do
		canvas:show()
	end
end

---@public
function M:hide()
	for _, canvas in ipairs(self.canvases) do
		canvas:hide()
	end
end

---@private
---@nodiscard
function M:makeElements(frame)
	return {
		{ type = "rectangle", action = "build" },
		{
			type = "rectangle",
			action = "clip",
			reversePath = true,
			frame = {
				x = 8,
				y = (self.margin / 2) + 22,
				h = frame.h,
				w = frame.w - self.margin,
			},
			roundedRectRadii = { xRadius = 8, yRadius = 8 },
		},
		{
			type = "rectangle",
			fillColor = { hex = "#f00", alpha = 0.5 },
			roundedRectRadii = { xRadius = 6, yRadius = 6 },
		},
		{
			type = "text",
			text = "Mouse Keys Active",
			textColor = { hex = "#fff", alpha = 1.0 },
			textAlignment = "center",
			textSize = 12,
			padding = 6,
		},
	}
end

return M
