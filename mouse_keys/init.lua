local hk = hs.hotkey
local bind = hk.bind
local mp = hs.mouse.absolutePosition
local fnu = hs.fnutils

---@module "mouse_keys"
local M = {}

---@type hs.hotkey.modal
local modal

---@type { [string]: string }
local directions = {
	h = "left",
	j = "down",
	k = "up",
	l = "right",
	a = "left",
	s = "down",
	w = "up",
	d = "right",
}

---@return nil
local function createModal()
	modal = hk.modal.new("", "f20", "Mouse Keys")
	modal:bind("", "escape", function() modal:exit() end)
end

---@type integer
local step_size = 2

---@type integer[]
local step_sizes = {
	15,
	30,
	60,
	90,
}

---@return nil
local function increase_step()
	if step_size == #step_sizes then return end
	step_size = step_size + 1
end

---@return nil
local function decrease_step_size()
	if step_size == 1 then return end
	step_size = step_size - 1
end

---@return integer
local function get_step() return step_sizes[step_size] end

---@return nil
local function bind_stepper()
	modal:bind("", "q", increase_step, nil, increase_step)
	modal:bind("", "u", increase_step, nil, increase_step)

	modal:bind("shift", "q", decrease_step_size, nil, decrease_step_size)
	modal:bind("shift", "u", decrease_step_size, nil, decrease_step_size)

	for i = 1, #step_sizes do
		modal:bind("", i .. "", function()
			step_size = i
			print(step_size, step_sizes[step_size])
		end)
	end
end

---@type { [string]: fun(): nil }
local mouse = {}

function mouse.up()
	local pos = mp()
	pos.y = pos.y - get_step()
	mp(pos)
end

function mouse.down()
	local pos = mp()
	pos.y = pos.y + get_step()
	mp(pos)
end

function mouse.left()
	local pos = mp()
	pos.x = pos.x - get_step()
	mp(pos)
end

function mouse.right()
	local pos = mp()
	pos.x = pos.x + get_step()
	mp(pos)
end

local function bind_movements()
	for key, direction in pairs(directions) do
		modal:bind("", key, mouse[direction], nil, mouse[direction])
	end
end

function M.setup()
	createModal()
	bind_movements()
	bind_stepper()
end

return M
