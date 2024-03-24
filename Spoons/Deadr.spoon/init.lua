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

---@public
obj.app_shortcuts = {}

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
	self.modal.entered = hs.fnutils.partial(self.entered, self)--[[@as function]]
	self.modal.exited = hs.fnutils.partial(self.exited, self)--[[@as function]]

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

function obj:activate(defs)
	local items = {}
	for _, item in ipairs(defs) do
		local key, app, desc = table.unpack(item)
		table.insert(items, { key, desc or app })
		if type(app) == "table" then
		elseif type(app) == "string" then
			self.modal:bind("", key, self.appOpener(app))
		end
	end
	self.hud:setItems(items)
	self.modal:enter()
end

function obj.appOpener(hint)
	if type(hint) == "function" then
		return hint
	end
	return function()
		local exact = true
		local app = hs.application.find(hint, exact)
		if app then
			if app:isFrontmost() then
				app:hide()
			else
				local allWindows = true
				app:setFrontmost(allWindows)
			end
		else
			hs.application.open(hint)
		end
	end
end

function obj:toggle()
	if self.hud:isShowing() then
		self:exit()
	else
		self:activate(self.app_shortcuts)
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
