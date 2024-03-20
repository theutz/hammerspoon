---@class (exact) Mousr
---@field name string
---@field version string
---@field author string
---@field license string
---@field homepage string
---@field indicator Indicator
local obj = {}

---@public
obj.name = "Mousr"

---@public
obj.version = "0.0.0"

---@public
obj.author = "Michael Utz <michael@theutz.com>"

---@public
obj.license = "MIT"

---@public
obj.homepage = "https://theutz.com"

---@enum step_mods
local step_mods = {
	INC = "ctrl",
	DEC = "shift",
}

---@enum directions
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

---@enum actions
local actions = {
	click = { "", "space" },
	rightClick = { "shift", "space" },
}

---@type integer
local step_size = 2

---@type integer[]
local step_sizes = {
	5,
	20,
	60,
	90,
}

---@type hs.hotkey.modal
local modal

local indicator

---@return nil
local function createModal()
	local activation_key = "f20"
	modal = hs.hotkey.modal.new("", activation_key)

	function modal:entered() ---@diagnostic disable-line duplicate-set-field
		obj.indicator:show()
	end

	function modal:exited() ---@diagnostic disable-line duplicate-set-field
		obj.indicator:hide()
	end

	for _, key in ipairs { "escape", activation_key } do
		modal:bind("", key, function() modal:exit() end)
	end
end

---@return nil
local function increaseStep()
	if step_size == #step_sizes then return end
	step_size = step_size + 1
end

---@return nil
local function decreaseStepSize()
	if step_size == 1 then return end
	step_size = step_size - 1
end

---@return integer
local function getStep()
	local mods = hs.eventtap.checkKeyboardModifiers() ---@cast mods { ["shift"|"ctrl"|"alt"]: boolean }

	if mods[step_mods.DEC] and step_size > 1 then return step_sizes[step_size - 1] end
	if mods[step_mods.INC] and step_size < #step_sizes then return step_sizes[step_size + 1] end

	return step_sizes[step_size]
end

---@return nil
local function bindStepper()
	modal:bind("", "q", increaseStep, nil, increaseStep)
	modal:bind("", "u", increaseStep, nil, increaseStep)

	modal:bind(step_mods.DEC, "q", decreaseStepSize, nil, decreaseStepSize)
	modal:bind(step_mods.DEC, "u", decreaseStepSize, nil, decreaseStepSize)

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
	pos.y = pos.y - getStep()
	hs.mouse.absolutePosition(pos)
end

function mouse.down()
	local pos = hs.mouse.absolutePosition()
	pos.y = pos.y + getStep()
	hs.mouse.absolutePosition(pos)
end

function mouse.left()
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x - getStep()
	hs.mouse.absolutePosition(pos)
end

function mouse.right()
	local pos = hs.mouse.absolutePosition()
	pos.x = pos.x + getStep()
	hs.mouse.absolutePosition(pos)
end

function mouse.click() hs.eventtap.leftClick(hs.mouse.absolutePosition()) end

function mouse.rightClick() hs.eventtap.rightClick(hs.mouse.absolutePosition()) end

---@return nil
local function bindMovements()
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

---@public
---@nodiscard
function obj:init()
	self.indicator = dofile(hs.spoons.resourcePath "indicator.lua")
	createModal()
	return self
end

---@public
---@nodiscard
function obj:bindHotKeys(mapping) return self end

---@public
---@nodiscard
function obj:start()
	bindMovements()
	bindStepper()
	return self
end

return obj
