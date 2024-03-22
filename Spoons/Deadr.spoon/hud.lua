---@class Hud
local M = {}

---@private
M.logger = hs.logger.new("hud")

---@private
M.canvas = hs.canvas.new(hs.screen.primaryScreen():frame()) --[[@as hs.canvas]]

---@alias hud.cells { [string]: { [1]: string[], [2]: string } }[]
---@private
M.cells = {}

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
---@param cells hud.cells
function M:setCells(cells)
	---@diagnostic disable param-type-mismatch
	self.logger.d("setting cells")
	self.logger.vf(hs.inspect(cells))
	---@diagnostic enable

	self.cells = cells

	return self
end

---@private
function M:renderCanvas()
	local frame = hs.screen.mainScreen():fullFrame()
	---@diagnostic disable-next-line: param-type-mismatch
	self.logger.vf("canvas frame: %s", hs.inspect(frame))

	local cells = self:buildCells()

	local container_size = frame:copy():scale("0.5x0.5")

	local container = hs.canvas.new(container_size):appendElements({
		{
			type = "rectangle",
			action = "fill",
			color = { hex = "#fff", alpha = 0.5 },
		},
		{
			type = "canvas",
			canvas = cells,
		},
	})

	local overlay = hs
		.canvas
		.new(frame) --[[@as hs.canvas]]
		:appendElements({
			{ type = "rectangle", fillColor = { hex = "#000", alpha = 0.2 } },
			{ type = "canvas", canvas = container },
		})
	M.canvas = overlay
end

---@private
---@return hs.canvas
function M:buildCells()
	local size = 140
	local margin = size / 10
	local rounded = 10
	local cell_fill = { hex = "#000", alpha = 0.9 }
	local text_color = { hex = "#55a" }
	local font = "IBM Plex Mono"

	local els = {}

	for i, c in ipairs(self.cells) do
		local key, name = table.unpack(c)
		local el = {
			type = "canvas",
			frame = {
				x = ((i - 1) * size) + (i * margin * 2),
				y = margin,
				h = size,
				w = size,
			},
			canvas = hs
				.canvas
				.new({})--[[@as hs.canvas]]
				:appendElements({
					type = "rectangle",
					action = "fill",
					fillColor = cell_fill,
					roundedRectRadii = {
						xRadius = rounded,
						yRadius = rounded,
					},
				}, {
					frame = { x = "10%", y = "20%", h = "30%", w = "80%" },
					text = hs
						.styledtext
						.new(key, {
							font = { name = font .. " Bold", size = 32 },
							color = text_color,
							paragraphStyle = {
								alignment = "center",
							},
						})--[[@as hs.styledtext]]
						:upper(),
					type = "text",
				}, {
					frame = { x = "10%", y = "60%", h = "50%", w = "80%" },
					text = hs.styledtext.new(name, {
						font = { name = font, size = 18 },
						color = text_color,
						paragraphStyle = {
							alignment = "center",
						},
					}),
					type = "text",
				}),
		}
		table.insert(els, el)
	end

	return hs
		.canvas
		.new({}) --[[@as hs.canvas]]
		:appendElements(els)
end

return M
