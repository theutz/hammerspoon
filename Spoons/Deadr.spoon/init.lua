---@class Deadr
local obj = {}

---@public
obj.name = "Deadr"

---@public
obj.author = "Michael Utz <michael@theutz.com>"

---@public
obj.version = "0.0.0"

---@public
obj.license = "MIT"

---@public
obj.homepage = "https://theutz.com"

---@private
obj.logger = hs.logger.new(obj.name)

---@private
obj.defaultHotkeys = {
	toggle = { {}, "f19" },
}

---@private
obj.hud = nil

---@private
obj.modal = nil

---@public
---@return self
function obj:init()
	self.hud = dofile(hs.spoons.resourcePath("hud.lua")):new({
		logger = self.logger,
	}) --[[@as Hud]]

	self.modal = hs.hotkey.modal.new()
	self.modal.entered = hs.fnutils.partial(self.entered, self)
	self.modal.exited = hs.fnutils.partial(self.exited, self)

	return self
end

---@public
---@return self
function obj:bindHotkeys(map)
	local def = {
		toggle = hs.fnutils.partial(self.toggle, self),
	}

	hs.spoons.bindHotkeysToSpec(def, map)

	self.modal:bind(
		map.toggle[1],
		map.toggle[2],
		hs.fnutils.partial(self.toggle, self)
	)
	self.modal:bind({ "" }, "escape", hs.fnutils.partial(self.exit, self))

	return self
end

function obj:start()
	self.hud:setItems({
		{ "1", "1Password" },
		{ "b", "Firefox" },
		{ "d", "Dash" },
		{ "t", "WezTerm" },
		{ "w", "Neovide" },
	})
end

function obj:toggle()
	if self.hud:isShowing() then
		self:exit()
	else
		self:enter()
	end
end

function obj:enter()
	self.modal:enter()
end

function obj:exit()
	self.modal:exit()
end

function obj:entered()
	self.hud:show()
end

function obj:exited()
	self.hud:hide()
end

return obj
