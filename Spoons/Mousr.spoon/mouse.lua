---@alias mover fun(self: self, step:integer): nil
---@alias clicker fun(self: self): nil

---@class (exact) Mouse
---@field public new fun(self: self, o: self): self
---@field public up mover
---@field public down mover
---@field public left mover
---@field public right mover
---@field public click clicker
---@field public rightClick clicker
---@field public __index self
---@field private logger hs.logger
local M = {}

---@nodiscard
function M:new(o)
	o = o or {}
	setmetatable(o, M)
	self.__index = self
	return o
end

function M:up(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("up %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y - step
	hs.mouse.absolutePosition(pos)
end

function M:down(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("down %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y + step
	hs.mouse.absolutePosition(pos)
end

function M:left(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("left %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x - step
	hs.mouse.absolutePosition(pos)
end

function M:right(step)
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.df("right %d", step)
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x + step
	hs.mouse.absolutePosition(pos)
end

function M:click()
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.d("do click")
	hs.eventtap.leftClick(hs.mouse.absolutePosition())
end

function M:rightClick()
	---@diagnostic disable-next-line param-type-mismatch
	self.logger.d("do right click")
	hs.eventtap.rightClick(hs.mouse.absolutePosition())
end

return M
