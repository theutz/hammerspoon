---@alias mover fun(self: Mouse, step:integer): nil
---@alias clicker fun(self: Mouse): nil

---@class Mouse
local M = {}

---@enum direction
M.direction = {
	UP = "move_up",
	DOWN = "move_down",
	LEFT = "move_left",
	RIGHT = "move_right",
}

---@enum action
M.action = {
	LEFT_CLICK = "left_click",
	RIGHT_CLICK = "right_click",
}

---@nodiscard
---@return self
function M:new(o)
	o = o or {}
	setmetatable(o, M)

	---@private
	self.__index = self

	return o
end

---@param step integer
function M:move_up(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("up %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y - step
	hs.mouse.absolutePosition(pos)
end

---@param step integer
function M:move_down(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("down %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y + step
	hs.mouse.absolutePosition(pos)
end

---@param step integer
function M:move_left(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("left %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x - step
	hs.mouse.absolutePosition(pos)
end

---@param step integer
function M:move_right(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("right %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x + step
	hs.mouse.absolutePosition(pos)
end

function M:left_click()
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.d("do click")
	hs.eventtap.leftClick(hs.mouse.absolutePosition())
end

function M:right_click()
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.d("do right click")
	hs.eventtap.rightClick(hs.mouse.absolutePosition())
end

return M
