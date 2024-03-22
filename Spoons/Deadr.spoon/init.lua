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
obj.defaultHotkeys = {}

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
	local def = {}

	hs.spoons.bindHotkeysToSpec(def, map)
	return self
end

function obj:start()
	obj.hud
		:setCells({
			{ "1", "1Password" },
			{ "b", "Firefox" },
			{ "d", "Dash" },
			{ "t", "WezTerm" },
			{ "w", "Neovide" },
		})
		:show()
end

return obj
