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

---@public
---@return self
function obj:init()
	obj.hud = dofile(hs.spoons.resourcePath("hud.lua")):new({
		logger = self.logger,
	}) --[[@as Hud]]

	return self
end

---@public
---@return self
function obj:bindHotkeys(map)
	local def = {
		toggle = hs.fnutils.partial(self.toggle, self),
	}

	hs.spoons.bindHotkeysToSpec(def, map)
	return self
end

function obj:start()
	obj.hud:setItems({
		{ "1", "1Password" },
		{ "b", "Firefox" },
		{ "d", "Dash" },
		{ "t", "WezTerm" },
		{ "w", "Neovide" },
		{ "1", "1Password" },
		{ "b", "Firefox" },
		{ "d", "Dash" },
		{ "t", "WezTerm" },
		{ "w", "Neovide" },
		{ "1", "1Password" },
		{ "b", "Firefox" },
		{ "d", "Dash" },
		{ "t", "WezTerm" },
		{ "w", "Neovide" },
		{ "1", "1Password" },
	})
end

function obj:toggle()
	if self.hud:isShowing() then
		self.hud:hide()
	else
		self.hud:show()
	end
end

return obj
