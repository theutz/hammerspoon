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
	modal = hs.hotkey.modal.new("", "f20", "Mouse Keys")
	modal:bind("", "escape", function() modal:exit() end)
end

---@type integer
local step_size = 2

---@type integer[]
local step_sizes = {
	5,
	20,
	60,
	90,
}

---@type { [string]: string }
local step_mods = {
	inc = "ctrl",
	dec = "shift",
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
local function get_step()
	local mods = hs.eventtap.checkKeyboardModifiers() ---@cast mods { ["shift"|"ctrl"|"alt"]: boolean }

	if mods[step_mods.dec] and step_size > 1 then return step_sizes[step_size - 1] end
	if mods[step_mods.inc] and step_size < #step_sizes then return step_sizes[step_size + 1] end

	return step_sizes[step_size]
end

---@return nil
local function bind_stepper()
	modal:bind("", "q", increase_step, nil, increase_step)
	modal:bind("", "u", increase_step, nil, increase_step)

	modal:bind(step_mods.dec, "q", decrease_step_size, nil, decrease_step_size)
	modal:bind(step_mods.dec, "u", decrease_step_size, nil, decrease_step_size)

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
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y - get_step()
	hs.mouse.absolutePosition(pos)
end

function mouse.down()
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y + get_step()
	hs.mouse.absolutePosition(pos)
end

function mouse.left()
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x - get_step()
	hs.mouse.absolutePosition(pos)
end

function mouse.right()
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x + get_step()
	hs.mouse.absolutePosition(pos)
end

local actions = {
	["click"] = { "", "space" },
	["rightClick"] = { "shift", "space" },
}

function mouse.click() hs.eventtap.leftClick(hs.mouse.absolutePosition()) end

function mouse.rightClick() hs.eventtap.rightClick(hs.mouse.absolutePosition()) end

---@return nil
local function bind_movements()
	local mods = { "" }
	for _, v in pairs(step_mods) do
		table.insert(mods, v)
	end

	for key, direction in pairs(directions) do
		for _, mod in ipairs(mods) do
			modal:bind(mod, key, mouse[direction], nil, mouse[direction])
		end
	end

	for action, spec in pairs(actions) do
		modal:bind(spec[1], spec[2], mouse[action], nil, mouse[action])
	end
end

---@return nil
function M.setup()
	createModal()
	bind_movements()
	bind_stepper()
end

return M
