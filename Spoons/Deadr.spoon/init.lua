local partial = hs.fnutils.partial

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
obj.binds = {}

---@private
obj.logger = hs.logger.new(obj.name)

---@public
obj.cell = {
	width = 120,
	height = 120,
	padding = 20,
	key = 36,
	name = 16,
}

---@public
obj.table = {
	padding = 20,
	gap = 10,
	cols = 5,
}

---@private { modal: hs.hotkey.modal, hud: Hud }[]
obj.layers = {}

---@public
---@return self
function obj:init()
	return self
end

---@public
---@return self
function obj:bindHotkeys(map)
	self.activate_keyspec = map.activate

	local def = {
		activate = hs.fnutils.partial(self.activate, self),
	}

	hs.spoons.bindHotkeysToSpec(def, map)

	return self
end

---@private
function obj.opener(hint, layer)
	local fn
	if type(hint) == "function" then
		fn = function()
			hint(obj.appToggler)
		end
	else
		fn = hs.fnutils.partial(obj.appToggler, hint) --[[@as function]]
	end
	return function()
		fn()
		layer:exit()
	end
end

---@public
function obj.appToggler(name)
	local exact = true
	local app = hs.application.find(name, exact)
	if app then
		if app:isFrontmost() then
			app:hide()
		else
			local allWindows = true
			app:setFrontmost(allWindows)
		end
	else
		hs.application.open(name)
	end
end

---@private
function obj:activate()
	if #self.layers > 0 then
		for _, layer in ipairs(self.layers) do
			layer.exit()
		end
		self.layers = {}
	end
	table.insert(self.layers, self:makeLayer(self.binds))
	self.layers[1].modal:enter()
end

---@private
function obj:makeLayer(defs)
	local layer = {
		modal = hs.hotkey.modal.new(),
		hud = dofile(hs.spoons.resourcePath("hud.lua")):new({
			logger = self.logger,
			table = self.table,
			cell = self.cell,
		}) --[[@as Hud]],
	}
	layer.exit = partial(layer.modal.exit, layer.modal)
	layer.enter = partial(layer.modal.enter, layer.modal)

	local items = {}

	for _, def in ipairs(defs) do
		local mods = { "" }
		local key, action = table.unpack(def)

		if type(action) == "string" then
			local app_name = action

			table.insert(items, { key, def.desc or app_name })

			layer.modal:bind(mods, key, self.opener(app_name, layer))
		elseif type(action) == "function" then
			assert(def.desc, "Custom actions must have a description")

			table.insert(items, { key, def.desc })

			layer.modal:bind(mods, key, self.opener(action, layer))
		elseif type(action) == "table" then
			local layers = action
			assert(def.desc, "Layers must have a description")

			table.insert(items, { key, def.desc })

			layer.modal:bind(mods, key, function()
				for _, l in ipairs(self.layers) do
					l.exit()
				end
				table.insert(self.layers, self:makeLayer(layers))
				self.layers[#self.layers].modal:enter()
			end)
		end
	end

	layer.hud:setItems(items)

	---@diagnostic disable-next-line: duplicate-set-field
	function layer.modal:entered()
		---@diagnostic disable-next-line: param-type-mismatch
		obj.logger.d("modal entered")
		layer.hud:show()
	end

	---@diagnostic disable-next-line: duplicate-set-field
	function layer.modal:exited()
		---@diagnostic disable-next-line: param-type-mismatch
		obj.logger.d("modal exited")
		layer.hud:hide()
	end

	local function closeTopLayer()
		layer.modal:exit()
		table.remove(self.layers)
		local curr = self.layers[#self.layers]
		if curr and curr.modal and curr.modal.enter then
			curr.modal:enter()
		end
	end
	layer.modal:bind("", "escape", closeTopLayer)

	local function closeAllLayers()
		for i, l in ipairs(self.layers) do
			l.exit()
			self.layers[i] = nil
		end
	end

	layer.modal:bind({ "shift" }, "escape", closeAllLayers)
	layer.modal:bind(
		self.activate_keyspec[1],
		self.activate_keyspec[2],
		closeAllLayers
	)

	return layer
end

return obj
