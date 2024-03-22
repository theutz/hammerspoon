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

---@public
---@return self
---@nodiscard
function obj:init()
	return self
end

---@public
---@return self
---@nodiscard
function obj:bindHotkeys(map)
	local def = {}

	hs.spoons.bindHotkeysToSpec(def, map)
	return self
end

return obj
