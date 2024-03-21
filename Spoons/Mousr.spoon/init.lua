---@alias keyspec { [1]: string, [2]: string }
---@alias mapping { activate: keyspec, deactivate: keyspec }

---@class (exact) Mousr
---@field private logger hs.logger
---@field public name string
---@field public version string
---@field public author string
---@field public license string
---@field public homepage string
---@field public bindHotkeys fun(s: self, m: mapping): self
---@field public init function
---@field public start function
---@field private initModal fun(s: self): hs.hotkey.modal
---@field private indicator Indicator
---@field private mouse Mouse
---@field private modal hs.hotkey.modal
---@field private onModalEntered fun(s: self): nil
---@field private onModalExited fun(s: self): nil
---@field private mapping mapping
local obj = {}

obj.name = "Mousr"
obj.version = "0.0.0"
obj.author = "Michael Utz <michael@theutz.com>"
obj.license = "MIT"
obj.homepage = "https://theutz.com"

---@enum step_mods
local step_mods = {
	DEC = "ctrl",
	INC = "shift",
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

obj.mapping = {
	activate = { "", "f20" },
	deactivate = { "", "escape" },
}

---@return nil
local function increaseStep()
	if step_size == #step_sizes then
		return
	end
	step_size = step_size + 1
end

---@return nil
local function decreaseStepSize()
	if step_size == 1 then
		return
	end
	step_size = step_size - 1
end

---@return integer
local function getStep()
	local mods = hs.eventtap.checkKeyboardModifiers()
	---@cast mods { ["shift"|"ctrl"|"alt"]: boolean }

	if mods[step_mods.DEC] and step_size > 1 then
		return step_sizes[step_size - 1]
	end
	if mods[step_mods.INC] and step_size < #step_sizes then
		return step_sizes[step_size + 1]
	end

	return step_sizes[step_size]
end

---@return nil
function obj:bindStepper()
	self.modal:bind("", "q", increaseStep, nil, increaseStep)
	self.modal:bind("", "u", increaseStep, nil, increaseStep)

	self.modal:bind(step_mods.DEC, "q", decreaseStepSize, nil, decreaseStepSize)
	self.modal:bind(step_mods.DEC, "u", decreaseStepSize, nil, decreaseStepSize)

	for i = 1, #step_sizes do
		self.modal:bind("", i .. "", function()
			step_size = i
			print(step_size, step_sizes[step_size])
		end)
	end
end

---@return nil
function obj:bindMovements()
	local mods = { "" }
	for _, v in pairs(step_mods) do
		table.insert(mods, v)
	end

	for key, direction in pairs(directions) do
		for _, mod in ipairs(mods) do
			local cb = function()
				obj.mouse[direction](obj.mouse, getStep())
			end
			self.modal:bind(mod, key, cb, nil, cb)
		end
	end

	for action, spec in pairs(actions) do
		self.modal:bind(
			spec[1],
			spec[2],
			obj.mouse[action],
			nil,
			obj.mouse[action]
		)
	end
end

---@nodiscard
function obj:init()
	self.logger = hs.logger.new("mousr")
	self.indicator = dofile(hs.spoons.resourcePath("indicator.lua")):new({
		logger = self.logger,
		margin = 16,
	})
	self.mouse = dofile(hs.spoons.resourcePath("mouse.lua")):new({
		logger = self.logger,
	})
	self.modal = self:initModal()

	return self
end

---@nodiscard
function obj:initModal()
	local modal = hs.hotkey.modal.new()
	modal.entered = self.onModalEntered
	modal.exited = self.onModalExited
	return modal
end

---@nodiscard
function obj:bindHotkeys(mapping)
	hs.hotkey.bind(mapping.activate[1], mapping.activate[2], self.enterModal)
	self.modal:bind(
		mapping.deactivate[1],
		mapping.deactivate[2],
		self.exitModal
	)
	self.modal:bind(mapping.activate[1], mapping.activate[2], self.exitModal)
	return self
end

function obj:onModalEntered()
	obj.indicator:show()
end

function obj:onModalExited()
	obj.indicator:hide()
end

function obj:enterModal()
	obj.modal:enter()
end

function obj:exitModal()
	obj.modal:exit()
end

---@nodiscard
function obj:start()
	self:bindMovements()
	self:bindStepper()

	return self
end

return obj
