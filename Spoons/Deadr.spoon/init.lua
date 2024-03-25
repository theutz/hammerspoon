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
obj.max_cols = 8

---@private
obj.defaultHotkeys = {
	activate = { {}, "f19" },
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
function obj.opener(hint)
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

---@private
function obj:activate()
	if #self.layers > 0 then
		for _, layer in ipairs(self.layers) do
			layer.modal:exit()
		end
		self.layers = {}
	end
	table.insert(self.layers, self:makeLayer(self.binds))
	self.layers[1].modal:enter()
end

---@private
function obj:makeLayer(defs)
	local modal = hs.hotkey.modal.new()
	local hud = dofile(hs.spoons.resourcePath("hud.lua")):new({
		logger = self.logger,
		max_cols = self.max_cols,
	}) --[[@as Hud]]

	local items = {}

	for _, def in ipairs(defs) do
		local mods = { "" }
		local key, action = table.unpack(def)

		if type(action) == "string" then
			local app_name = action

			table.insert(items, { key, def.desc or app_name })

			modal:bind(mods, key, self.opener(app_name))
		elseif type(action) == "function" then
			assert(def.desc, "Custom actions must have a description")

			table.insert(items, { key, def.desc })

			modal:bind(mods, key, self.opener(action))
		elseif type(action) == "table" then
			local layers = action
			assert(def.desc, "Layers must have a description")

			table.insert(items, { key, def.desc })

			modal:bind(mods, key, function()
				for _, layer in ipairs(self.layers) do
					layer.modal:exit()
				end
				table.insert(self.layers, self:makeLayer(layers))
				self.layers[#self.layers].modal:enter()
			end)
		end
	end

	hud:setItems(items)

	---@diagnostic disable-next-line: duplicate-set-field
	function modal:entered()
		---@diagnostic disable-next-line: param-type-mismatch
		obj.logger.d("modal entered")
		hud:show()
	end

	---@diagnostic disable-next-line: duplicate-set-field
	function modal:exited()
		---@diagnostic disable-next-line: param-type-mismatch
		obj.logger.d("modal exited")
		hud:hide()
	end

	local function closeTopLayer()
		modal:exit()
		table.remove(self.layers)
		local curr = self.layers[#self.layers]
		if curr and curr.modal and curr.modal.enter then
			curr.modal:enter()
		end
	end
	modal:bind("", "escape", closeTopLayer)

	local function closeAllLayers()
		for i, layer in ipairs(self.layers) do
			layer.modal:exit()
			self.layers[i] = nil
		end
	end

	modal:bind({ "shift" }, "escape", closeAllLayers)
	modal:bind(
		self.activate_keyspec[1],
		self.activate_keyspec[2],
		closeAllLayers
	)

	return { modal = modal, hud = hud }
end

return obj
