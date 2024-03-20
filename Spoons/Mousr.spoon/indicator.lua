---@class (exact) Indicator
---@field private canvases hs.canvas[]
---@field private makeElements fun(frame: hs.geometry): hs.canvas[]
---@field private margin integer
---@field public show fun(self: self): nil
---@field public hide fun(self: self): nil
---@field new fun(margin?: integer): self
local M = {}

M.canvases = {}

M.margin = 16

---@nodiscard
function M.makeElements(frame)
	local margin = 16
	return {
		{ type = "rectangle", action = "build" },
		{
			type = "rectangle",
			action = "clip",
			reversePath = true,
			frame = { x = 8, y = (margin / 2) + 22, h = frame.h, w = frame.w - margin },
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

---@nodiscard
function M.new(margin)
	local metatable = {}
	local instance = setmetatable(metatable, M)
	return instance
end

function M:show()
	local screens = hs.screen.allScreens() ---@cast screens hs.screen[]

	for i, screen in ipairs(screens) do
		local frame = screen:frame()
		M.canvases[i] = hs.canvas.new(screen:fullFrame())
		M.canvases[i]:appendElements(M.makeElements(frame))
		M.canvases[i]:behavior { "canJoinAllSpaces", "stationary" }
	end

	for _, alert in ipairs(M.canvases) do
		alert:show()
	end
end

function M:hide()
	for _, alert in ipairs(M.canvases) do
		alert:hide()
	end
end

return M
