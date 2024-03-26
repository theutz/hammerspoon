---@class Hud
local M = {}

---@private
M.logger = hs.logger.new("hud")

---@private
M.canvas = hs.canvas.new(hs.screen.primaryScreen():frame()) --[[@as hs.canvas]]

---@alias hud.cells { [string]: { [1]: string[], [2]: string } }[]
---@private
M.items = {}

---@public
M.cell = {
	width = 120,
	height = 120,
	key = 36,
	name = 16,
}

---@public
M.table = {
	padding = 20,
	gap = 10,
	cols = 5,
}

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

	table.sort(items, function(a, b)
		if a[1] == b[1] then
			return a[2] < b[2]
		else
			return a[1] < b[1]
		end
	end)
	self.items = items

	return self
end

function M:renderCanvas()
	local screenFrame = hs.screen.mainScreen():fullFrame()

	local width = self.cell.width or 120
	local height = self.cell.height or 120
	local padding = self.table.padding or 20
	local gap = self.table.gap or 10
	local max_cols = self.table.cols or 8

	local cell_count = #self.items
	local row_count = math.ceil(cell_count / max_cols)
	local col_count = cell_count <= max_cols and cell_count or max_cols
	local remaining_cells = cell_count % max_cols

	local canvas = hs.canvas.new(screenFrame) --[[@as hs.canvas]]
	canvas:behavior({
		"canJoinAllSpaces",
		"fullScreenAuxiliary",
		"fullScreenDisallowsTiling",
		"transient",
	})

	canvas[1] = {
		id = "overlay",
		type = "rectangle",
		action = "fill",
		fillColor = { hex = "#000", alpha = 0.3 },
	}

	canvas[2] = {
		id = "container",
		type = "rectangle",
		action = "fill",
		fillColor = { hex = "#33a", alpha = 0.8 },
		frame = {
			x = 0,
			y = 0,
			w = col_count * width + (col_count - 1) * gap + padding * 2,
			h = row_count * height + (row_count - 1) * gap + padding * 2,
		},
		roundedRectRadii = { xRadius = 16, yRadius = 16 },
	}

	canvas[2].frame.x = (screenFrame.w - canvas[2].frame.w) / 2
	canvas[2].frame.y = (screenFrame.h - canvas[2].frame.h) / 2

	local container = hs.geometry.new(canvas[2].frame)

	for i, item in ipairs(self.items) do
		local row = math.ceil(i / max_cols)
		local col = i % max_cols == 0 and max_cols or i % max_cols
		local curr = canvas:elementCount()
		local key, name = table.unpack(item)
		local text = hs.styledtext.new(name, {
			font = { name = "IBM Plex Mono", size = self.cell.name or 16 },
			color = { hex = "#fff" },
			paragraphStyle = {
				alignment = "center",
			},
		})--[[@as hs.styledtext]]

		local cell = {
			id = "cell" .. i,
			type = "rectangle",
			fillColor = { hex = "#000" },
			frame = {
				x = container.x
					+ padding
					+ (col - 1) * width
					+ (gap * (col - 1)),
				y = container.y
					+ padding
					+ (row - 1) * height
					+ (gap * (row - 1)),
				w = width,
				h = height,
			},
			roundedRectRadii = { xRadius = 8, yRadius = 8 },
		}

		local key_box = {
			type = "text",
			text = text
				.copy(text)--[[@as hs.styledtext]]
				:setStyle({ font = { size = self.cell.key or 36 } })--[[@as hs.styledtext]]
				:setString(key)--[[@as hs.styledtext]]
				:upper(),
			frame = {
				x = cell.frame.x + gap,
				y = cell.frame.y + gap,
				w = cell.frame.w - gap * 2,
				h = (cell.frame.h - gap * 2) / 2,
			},
		}

		local name_box = {
			type = "text",
			text = text,
			frame = {
				x = cell.frame.x + gap,
				y = cell.frame.y + gap + cell.frame.h / 2,
				w = cell.frame.w - gap * 2,
				h = (cell.frame.h - gap * 2) / 2,
			},
		}

		local is_last_row = (math.ceil(i / max_cols) == row_count)

		if is_last_row and remaining_cells > 0 and row_count > 1 then
			local x_offset_count = (max_cols - remaining_cells) / 2
			local x_offset = x_offset_count * width + x_offset_count * gap
			cell.frame.x = cell.frame.x + x_offset
			key_box.frame.x = key_box.frame.x + x_offset
			name_box.frame.x = name_box.frame.x + x_offset
		end

		canvas[curr + 1] = cell
		canvas[curr + 2] = key_box
		canvas[curr + 3] = name_box
	end

	self.canvas = canvas
end

return M
