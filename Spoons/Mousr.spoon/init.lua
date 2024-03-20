---@class (exact) Mousr
---@field name string
---@field version string
---@field author string
---@field license string
---@field homepage string
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

---@type hs.canvas[]
local alerts = {}

local function showAlerts()
	---@param frame hs.geometry
	local function makeElements(frame)
		local margin = 16
		return {
			{ type = "rectangle", action = "build" },
			{
				type = "rectangle",
				action = "clip",
				reversePath = true,
				frame = { x = 8, y = (margin / 2) + 22, h = frame.h, w = frame.w - margin },
				roundedRectRadii = { xRadius = 8, yRadius = 8 },
			},
			{
				type = "rectangle",
				fillColor = { hex = "#f00", alpha = 0.5 },
				roundedRectRadii = { xRadius = 6, yRadius = 6 },
			},
			{
				type = "text",
				text = "Mouse Keys Active",
				textColor = { hex = "#fff", alpha = 1.0 },
				textAlignment = "center",
				textSize = 12,
				padding = 6,
			},
		}
	end

	local screens = hs.screen.allScreens() ---@cast screens hs.screen[]
	for i, screen in ipairs(screens) do
		local frame = screen:frame()
		alerts[i] = hs.canvas.new(screen:fullFrame())
		alerts[i]:appendElements(makeElements(frame))
		alerts[i]:behavior { "canJoinAllSpaces", "stationary" }
	end

	for _, alert in ipairs(alerts) do
		alert:show()
	end
end

local function hideAlerts()
	for _, alert in ipairs(alerts) do
		alert:hide()
	end
end

---@param self hs.hotkey.modal
---@return nil
local function onModalEnter(self) ---@diagnostic disable-line unused-local
	showAlerts()
end

---@param self hs.hotkey.modal
---@return nil
local function onModalExit(self) ---@diagnostic disable-line unused-local
	hideAlerts()
end

---@return nil
local function createModal()
	local activation_key = "f20"
	modal = hs.hotkey.modal.new("", activation_key)

	modal.exited = onModalExit
	modal.entered = onModalEnter

	for _, key in ipairs { "escape", activation_key } do
		modal:bind("", key, function() modal:exit() end)
	end
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

	if mods[step_mods.dec] and step_size > 1 then return step_sizes[step_size - 1] end
	if mods[step_mods.inc] and step_size < #step_sizes then return step_sizes[step_size + 1] end

	return step_sizes[step_size]
end

---@return nil
local function bindStepper()
	modal:bind("", "q", increaseStep, nil, increaseStep)
	modal:bind("", "u", increaseStep, nil, increaseStep)

	modal:bind(step_mods.dec, "q", decreaseStepSize, nil, decreaseStepSize)
	modal:bind(step_mods.dec, "u", decreaseStepSize, nil, decreaseStepSize)

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

local actions = {
	["click"] = { "", "space" },
	["rightClick"] = { "shift", "space" },
}

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
