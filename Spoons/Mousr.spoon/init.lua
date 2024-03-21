local partial = hs.fnutils.partial

---@alias keyspec { [1]: string, [2]: string }
---@alias mapping { activate: keyspec, deactivate: keyspec }

---@class Mousr
local obj = {}

obj.name = "Mousr"
obj.version = "0.0.0"
obj.author = "Michael Utz <michael@theutz.com>"
obj.license = "MIT"
obj.homepage = "https://theutz.com"

obj.mapping = {
	activate = { "", "f20" },
	deactivate = { "", "escape" },
	leftClick = { "", "space" },
	rightClick = { "shift", "space" },
	faster = { "shift" },
	slower = { "ctrl" },
	left = { "", "h" },
	down = { "", "j" },
	up = { "", "k" },
	right = { "", "l" },
}

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
	local m = {}

	-- set default values
	for k, _ in pairs(self.mapping) do
		m[k] = mapping[k] or self.mapping[k]
	end

	-- activate the modal
	do
		local mod, key = table.unpack(m.activate)
		hs.hotkey.bind(mod, key, self.enterModal)
		self.modal:bind(mod, key, self.exitModal)
	end

	-- deactivate the modal
	do
		local mod, key = table.unpack(m.deactivate)
		self.modal:bind(mod, key, self.exitModal)
	end

	-- perform actions
	for _, act in pairs(self.mouse.action) do
		local mod, key = table.unpack(m[act])
		local cb = partial(self.mouse[act], self.mouse)
		self.modal:bind(mod, key, cb)
	end

	-- move the mouse
	for mod, step in pairs({
		[m.slower] = 10,
		[""] = 20,
		[m.faster] = 50,
	}) do
		for _, dir in pairs(self.mouse.direction) do
			local _, key = table.unpack(m[dir])
			local cb = partial(self.mouse[dir], self.mouse, step)
			self.modal:bind(mod, key, cb, nil, cb)
		end
	end

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

return obj
