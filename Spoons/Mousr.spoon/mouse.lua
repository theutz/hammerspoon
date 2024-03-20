---@alias mover fun(step:integer): nil
---@alias clicker fun(): nil

---@class (exact) Mouse
---@field new fun(): self
---@field up mover
---@field down mover
---@field left mover
---@field right mover
---@field click clicker
---@field rightClick clicker
local M = {}

function M.new()
	local metatable = {}
	local instance = setmetatable(metatable, M)
	return instance
end

function M.up(step)
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y - step
	hs.mouse.absolutePosition(pos)
end

function M.down(step)
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y + step
	hs.mouse.absolutePosition(pos)
end

function M.left(step)
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x - step
	hs.mouse.absolutePosition(pos)
end

function M.right(step)
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x + step
	hs.mouse.absolutePosition(pos)
end

function M.click() hs.eventtap.leftClick(hs.mouse.absolutePosition()) end

function M.rightClick() hs.eventtap.rightClick(hs.mouse.absolutePosition()) end

return M
