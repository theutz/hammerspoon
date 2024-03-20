---@alias mover fun(self: self, step:integer): nil
---@alias clicker fun(self: self): nil

---@class (exact) Mouse
---@field new fun(self: self, o: self): self
---@field up mover
---@field down mover
---@field left mover
---@field right mover
---@field click clicker
---@field rightClick clicker
---@field __index self
---@field logger hs.logger
local M = {}

---@public
---@nodiscard
function M:new(o)
	o = o or {}
	setmetatable(o, M)
	self.__index = self
	return o
end

---@public
function M:up(step)
	self.logger.df("up %d", step) ---@diagnostic disable-line param-type-mismatch
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y - step
	hs.mouse.absolutePosition(pos)
end

---@public
function M:down(step)
	self.logger.df("down %d", step) ---@diagnostic disable-line param-type-mismatch
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y + step
	hs.mouse.absolutePosition(pos)
end

---@public
function M:left(step)
	self.logger.df("left %d", step) ---@diagnostic disable-line param-type-mismatch
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x - step
	hs.mouse.absolutePosition(pos)
end

---@public
function M:right(step)
	self.logger.df("right %d", step) ---@diagnostic disable-line param-type-mismatch
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x + step
	hs.mouse.absolutePosition(pos)
end

---@public
function M:click()
	self.logger.d "do click" ---@diagnostic disable-line param-type-mismatch
	hs.eventtap.leftClick(hs.mouse.absolutePosition())
end

---@public
function M:rightClick()
	self.logger.d "do right click" ---@diagnostic disable-line param-type-mismatch
	hs.eventtap.rightClick(hs.mouse.absolutePosition())
end

return M
