---@alias mover fun(self: Mouse, step:integer): nil
---@alias clicker fun(self: Mouse): nil

---@class Mouse
local M = {}

---@enum
M.direction = {
	UP = "up",
	DOWN = "down",
	LEFT = "left",
	RIGHT = "right",
}

M.action = {
	LEFT_CLICK = "leftClick",
	RIGHT_CLICK = "rightClick",
}

---@nodiscard
---@return self
function M:new(o)
	o = o or {}
	setmetatable(o, M)
	self.__index = self
	return o
end

---@type mover
function M:up(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("up %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y - step
	hs.mouse.absolutePosition(pos)
end

---@type mover
function M:down(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("down %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y + step
	hs.mouse.absolutePosition(pos)
end

---@type mover
function M:left(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("left %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x - step
	hs.mouse.absolutePosition(pos)
end

---@type mover
function M:right(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("right %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x + step
	hs.mouse.absolutePosition(pos)
end

---@type clicker
function M:leftClick()
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.d("do click")
	hs.eventtap.leftClick(hs.mouse.absolutePosition())
end

---@type clicker
function M:rightClick()
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.d("do right click")
	hs.eventtap.rightClick(hs.mouse.absolutePosition())
end

return M
